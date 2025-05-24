FROM python:3.9-slim

WORKDIR /home/myapp

# Install required packages and curl for healthcheck
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir flask requests

# Copy application files
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    FLASK_ENV=production \
    PORT=5050

# Add non-root user for security
RUN groupadd -r appuser && \
    useradd -r -g appuser appuser && \
    chown -R appuser:appuser /home/myapp

# Switch to non-root user
USER appuser

# Expose port
EXPOSE ${PORT}

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:${PORT}/ || exit 1

# Start application
CMD ["python3", "sample_app.py"] 