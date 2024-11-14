#ddev-generated
FROM cypress/included:13.11.0

# Set the working directory
WORKDIR /e2e

# Clean up .npm folder to fix errors when installing packages
RUN rm -rf /root/.npm
# Install npm package(s) at will (you can also run commands in container, `ddev ssh -s cypress`
# RUN npm install --save-dev cypress-terminal-report
