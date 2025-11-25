FROM mcr.microsoft.com/playwright:v1.39.0-jammy
RUN npm install -g netlify-cli@20.1.1 serve
RUN apt update
RUN apt install jq -y
RUN apt install python3-pip -y
RUN pip install numpy