workspace {
    name "Социальная сеть"
# папка с дополнительной документацией
    #!docs documentation 
# папка с архитектурными решениями
    #!adrs decisions
    model {
        user = person "Пользователь"
        other_user = person "Другой пользователь"
        social_network = softwareSystem "Социальная сеть"

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

        #systemContext social_network {
         #   include *
        #    autoLayout
        #}
    }
}
