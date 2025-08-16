Documentation:

https://github.com/terraform-routeros/terraform-provider-routeros/tree/main?tab=readme-ov-file
https://help.mikrotik.com/docs/spaces/ROS/pages/8323208/Netwatch
https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs
https://help.mikrotik.com/docs/spaces/ROS/pages/47579162/REST+API


Создаём корневой (CA) сертификат
/system certificate add name=myCA common-name=myCA key-usage=key-cert-sign,crl-sign

Подписываем его
/system certificate sign myCA

Создаём серверный сертификат для роутера
/system certificate add name=myServer common-name=192.168.88.1 subject-alt-name=IP:192.168.88.1 key-usage=digital-signature,key-encipherment,tls-server

Подписываем его нашим CA
/system certificate sign myServer ca=myCA

Разрешаем HTTPS GUI + REST API
/ip service set www-ssl disabled=no certificate=myServer

Отключаем обычный HTTP
/ip service set www disabled=yes

Включаем REST API (работает поверх www-ssl)
/ip service set api-ssl disabled=no certificate=myServer

Запуск проекта:

terraform init

terraform validate

terraform plan -out=tfplan

terraform apply tfplan

--- Оповещение о переключении на резервную сеть ---

Решил реализовать это через телеграм, как он постоянно под рукой и можно быстро реагировать,
Оповещение можно настроить как в личные сообщения конкретному человеку так и групповой чат с админами

--- Коментарий от себя ---

Задание оказалось очень сложным для меня, так как никогда раньше ничем подобным не занимался. Не уверен в правильности его выполнения,
также думаю что есть и другие более 'Best practice' решения, но как есть
В целом очень интересный опыт, правда болят глаза от документации
Надеюсь на ваш фидбек с разбором ошибок

Спасибо и хорошего дня :)

--- Коментарий от себя ---