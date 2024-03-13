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
        other_user = person "Другой пользователь"

        social_network = softwareSystem "Социальная сеть" {
            description "text"

            user_service = container "Text" {
                description "text"
            }

            #temperature_service = container "Temperature service" {
             #   description "Сервис мониторинга и управления температурой в доме"
            #}

            group "Слой данных" {
                user_database = container "User Database" {
                    description "База данных пользователями"
                    technology "PostgreSQL 15"
                    tags "database"
                }

                user_cache = container "User Cache" {
                    description "Кеш пользовательских данных для ускорения аутентификации"
                    technology "Redis"
                    tags "database"
                }

                tweets = container "Tweet Database" {
                    description "База данных для хранения постов на стене пользователя"
                    technology "MongoDB 5"
                    tags "database"
                }
                user_cache = container "Tweet Cache" {
                    description "Кеш пользовательских данных для ускорения аутентификации"
                    technology "Redis"
                    tags "database"
                }
            }





        user -> social_network "Делает публикации, общается с пользователем"
        other_user -> social_network "Делает публикации, общается с пользователем"
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
