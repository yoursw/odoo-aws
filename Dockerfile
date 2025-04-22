FROM odoo:16.0

# Install additional dependencies
USER root
RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    psycopg2-binary \
    python-ldap

# Copy custom configuration
COPY ./config/odoo.conf /etc/odoo/

# Switch back to odoo user
USER odoo

EXPOSE 8069