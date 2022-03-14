# python base image in the container from Docker Hub
FROM python:3.7.9-slim

# copy files to the /app folder in the container
COPY ./main.py /app/main.py
COPY ./Pipfile /app/Pipfile
COPY ./Pipfile.lock /app/Pipfile.lock
COPY init_container.sh /opt/startup

# set the working directory in the container to be /app
WORKDIR /app

# install the packages from the Pipfile in the container
RUN pip install pipenv
RUN pipenv install --system --deploy --ignore-pipfile

RUN apt-get update \
&& apt-get install -y --no-install-recommends openssh-server \
&& echo "root:Docker!" | chpasswd

RUN chmod 755 /opt/startup/init_container.sh

# expose the port that uvicorn will run the app on
ENV PORT=8000
EXPOSE 8000
EXPOSE 2222 80

ENTRYPOINT ["/opt/startup/init_container.sh"]   

# execute the command python main.py (in the WORKDIR) to start the app
CMD ["python", "main.py"]