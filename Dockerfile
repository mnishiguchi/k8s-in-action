FROM node:12

ADD app.js /app.js

# The command to execute when the image is run
ENTRYPOINT ["node", "app.js"]
