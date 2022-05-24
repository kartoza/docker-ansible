FROM python:3.9.12-bullseye

RUN apt update && apt -y upgrade

RUN python -m pip install ansible

RUN apt -y install sshpass

COPY docker-init.sh /usr/local/bin/docker-init.sh

RUN apt -y install dos2unix

RUN dos2unix /usr/local/bin/docker-init.sh

RUN chmod +x /usr/local/bin/docker-init.sh

CMD [ "/usr/local/bin/docker-init.sh" ]
