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
                    description "Кеши"
                    technology "Redis"
                    tags "database"
                }
            }
            user -> cache "Получение/обновление ленты постов друзей и списка друзей"
            database -> cache "Подготовка ленты пользователей и списка друзей"
            user -> service "Написание постов, написание/получение сообщений, добавление/удаление из друзей"
        }


        user -> social_network "Делает публикации, отправляет/получает сообщения"
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

    }
}
