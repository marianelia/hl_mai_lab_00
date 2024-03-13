workspace {
    name "Социальная сеть"
    description "Социальная сеть с постами и возможностью отправки сообщений (PtP)"
     # включаем режим с иерархической системой идентификаторов
    !identifiers hierarchical

# папка с дополнительной документацией
    #!docs documentation 
# папка с архитектурными решениями
    #!adrs decisions

    model {
        # Настраиваем возможность создания вложенных груп
        properties { 
            structurizr.groupSeparator "/"
        }

        user = person "Пользователь"

        social_network = softwareSystem "Социальная сеть" {
            description "text"

            service = container "Социальная сеть" {
               description "Социальная сеть с API"
            }

            group "Слой данных" {
                database = container "Database" {
                    description "База данных с пользователями, постами и сообщениями"
                    technology "PostgreSQL 15"
                    tags "database"
                }

                cache = container "Cache" {
                    description "Кэши"
                    technology "Redis"
                    tags "database"
                }
            }

            user -> service "Написание постов, написание/получение сообщений, добавление/удаление подписчиков"
            service -> database "Перемещение данных"
            service -> cache "Получение/обновление ленты постов подписчиков"
        }

        user -> social_network "Делает публикации, отправляет/получает сообщения, добавление/удаление подписчикой"

        deploymentEnvironment "Production" {
            deploymentNode "User Server" {
                containerInstance social_network.service
                instances 3
                properties {
                    "cpu" "2"
                    "ram" "2Gb"
                    "hdd" "10Gb"
                }
            }

            deploymentNode "Databases" {
                deploymentNode "Database Server" {
                    containerInstance social_network.database
                }

                deploymentNode "Cache Server" {
                    containerInstance social_network.cache
                }
            }
            
        }
    }

    views {
        themes default

        properties { 
            structurizr.tooltips true
        }
        
        !script groovy {
            workspace.views.createDefaultViews()
            workspace.views.views.findAll { it instanceof com.structurizr.view.ModelView }.each { it.enableAutomaticLayout() }
        }

        
        dynamic social_network "UC01" "Создание нового пользователя" {
            autoLayout
            user -> social_network.service "Создать нового пользователя (POST /user)"
            social_network.service -> social_network.database "Сохранить данные о пользователе" 
        }

        dynamic social_network "UC02" "Поиск пользователя по логину" {
            autoLayout
            user -> social_network.service "Поиск пользователя по логину (GET /user)"
            social_network.service -> social_network.database "Поиск пользователя в БД"
        }

        dynamic social_network "UC03" "Поиск пользователя по маске имя и фамилии" {
            autoLayout
            user -> social_network.service "Поиск пользователя по маске (GET /user)"
            social_network.service -> social_network.database "Поиск пользователя в БД"
        }

        dynamic social_network "UC04" "Добавление записи на стену" {
            autoLayout
            user -> social_network.service "Добавление записи на стену (POST /tweet)"
            social_network.service -> social_network.database "Добавление записи в БД" 
            social_network.service -> social_network.cache "Добавление новой записи в кэш стены пользователей-подписчиков"
        }

        dynamic social_network "UC05" "Загрузка стены пользователя" {
            autoLayout
            user -> social_network.service "Загрузка стены пользователя (GET /feed)"
            social_network.service -> social_network.cache "Загрузка стены"
            social_network.service -> social_network.database "Подгрузка записей из БД"
        }

        dynamic social_network "UC06" "Отправка сообщения пользователю" {
            autoLayout
            user -> social_network.service "Отправка сообщения пользователю (POST /im)"
            social_network.service -> social_network.database "Получение данных о доставках" 
        }
        dynamic social_network "UC07" "Получение списка сообщения для пользователя" {
            autoLayout
            user -> social_network.service "Получение списка сообщений по пользователю (GET /im)"
            social_network.service -> social_network.cache "Получение списка сообщений для пользователя" 
            social_network.service -> social_network.database "Подгрузка старых сообщений из БД"
            
        }

        styles {
            element "database" {
                shape cylinder
            }
        }

    }
}
