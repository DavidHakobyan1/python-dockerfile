FROM python:3.8-slim-buster

LABEL AUTHOR=david@example.com

LABEL VERSION=0.1.0

LABEL description="Python application using the \
                   Flask framework ."

ENV APP=/app

WORKDIR ${APP}

COPY requirements.txt requirements.txt

ADD file.tar.gz /opt

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . .

ARG USERNAME=user-david

ARG USER_UID=1000

ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

ENV env_USERNAME=$USERNAME

EXPOSE 5000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
