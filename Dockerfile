FROM python:3.7-slim AS compile-image
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc

# To enable the virtual environment.
RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
# Also it activates the venv and all teh binaries and dependencies are set in /opt/venv/bin/ directory, just like in m2 folder in Java.
# On activating venv the environment variable PATH is set by default. Hence we used it.
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt


FROM python:3.7-slim AS build-image
RUN adduser --disabled-password harshit
RUN adduser --group chaurasia
COPY --from=compile-image /opt/venv /opt/venv

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
COPY . .
USER harshit:chaurasia
CMD ["python", "app.py"]
