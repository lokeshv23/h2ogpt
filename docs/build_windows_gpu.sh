# https://pypi.org/project/pynsist/
# https://stackoverflow.com/questions/69352179/package-streamlit-app-and-run-executable-on-windows/69621578#69621578
# see also https://stackoverflow.com/questions/17428199/python-windows-installer-with-all-dependencies
# see also https://cyrille.rossant.net/create-a-standalone-windows-installer-for-your-python-application/
# see also https://pyinstaller.org/en/stable/operating-mode.html

# install NSIS:
# http://nsis.sourceforge.net/Download

# pip install pynsist


# make wheels for some things not on pypi
pip wheel antlr4-python3-runtime==4.9.3
pip wheel ffmpy==0.3.1
pip wheel fire==0.5.0
pip wheel future==0.18.3
pip wheel hnswlib==0.7.0
pip wheel intervaltree==3.1.0
pip wheel iopath==0.1.10
pip wheel olefile==0.46
pip wheel pycocotools==2.0.6
pip wheel python-docx==0.8.11
pip wheel python-pptx==0.6.21
pip wheel rouge-score==0.1.2
pip wheel sentence-transformers==2.2.2
pip wheel sgmllib3k==1.0.0
pip wheel validators==0.20.0
pip wheel python-magic-bin==0.4.14
pip wheel setuptools
# CPU only
pip wheel torch==2.0.1 --extra-index-url https://download.pytorch.org/whl/cpu
pip wheel llama_cpp_python==0.1.73
# GPU only
pip wheel torch==2.0.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117
pip wheel https://github.com/jllllll/bitsandbytes-windows-webui/releases/download/wheels/bitsandbytes-0.41.1-py3-none-win_amd64.whl
pip wheel https://github.com/PanQiWei/AutoGPTQ/releases/download/v0.4.2/auto_gptq-0.4.2+cu118-cp310-cp310-win_amd64.whl
pip wheel https://github.com/jllllll/exllama/releases/download/0.0.13/exllama-0.0.13+cu118-cp310-cp310-win_amd64.whl
pip wheel https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/download/textgen-webui/llama_cpp_python_cuda-0.1.73+cu117-cp310-cp310-win_amd64.whl
pip wheel https://h2o-release.s3.amazonaws.com/h2ogpt/hnswmiglib-0.7.0.tgz
pip wheel PyPika==0.48.9
pip wheel tabula==1.0.5
pip wheel chroma-hnswlib==0.7.3

mkdir wheels
move *.whl wheels

cd wheels

# GPU only
del torch-2.0.1-cp310-cp310-win_amd64.whl
del llama_cpp_python-0.1.73*.whl
move auto_gptq-0.4.2+cu118-cp310-cp310-win_amd64.whl auto_gptq-0.4.2-cp310-cp310-win_amd64.whl
move exllama-0.0.13+cu118-cp310-cp310-win_amd64.whl exllama-0.0.13-cp310-cp310-win_amd64.whl
move llama_cpp_python_cuda-0.1.73+cu117-cp310-cp310-win_amd64.whl llama_cpp_python_cuda-0.1.73-cp310-cp310-win_amd64.whl
move torch-2.0.1+cu117-cp310-cp310-win_amd64.whl torch-2.0.1-cp310-cp310-win_amd64.whl
# CPU only
del llama_cpp_python_cuda*.whl
del auto_gptq*.whl
del exllama-*.whl
del torch-2.0.1+cu117*.whl
move torch-2.0.1+cpu-cp310-cp310-win_amd64.whl torch-2.0.1-cp310-cp310-win_amd64.whl

cd ..


# Download: https://github.com/oschwartz10612/poppler-windows/releases/download/v23.08.0-0/Release-23.08.0-0.zip
unzip Release-23.08.0-0.zip
move poppler-23.08.0 poppler

# Install: https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20230401.exe
# copy from install path to local path
mkdir Tesseract-OCR
xcopy C:\Users\pseud\AppData\Local\Programs\Tesseract-OCR Tesseract-OCR  /s /e /h  # say specifies Directory

python src/basic_nltk.py

del C:\Users\pseud\AppData\Local\ms-playwright ms-playwright
playwright install
xcopy C:\Users\pseud\AppData\Local\ms-playwright ms-playwright /s /e /h  # say specifies Directory

# build
# for CPU, ensure win_rup_app.py sets CVD=''
python -m nsist windows_installer.cfg

# test
python run_app.py


# these changes required for GPU build:
#diff --git a/windows_installer.cfg b/windows_installer.cfg
#index 120d284..ea71ea0 100644
#--- a/windows_installer.cfg
#+++ b/windows_installer.cfg
#@@ -34,7 +34,7 @@ pypi_wheels = absl-py==1.4.0
#     Authlib==1.2.1
#     # GPU
#-    # auto_gptq==0.4.2
#+    auto_gptq==0.4.2
#     backoff==2.2.1
#     beautifulsoup4==4.12.2
#     bioc==2.0
#@@ -73,7 +73,7 @@ pypi_wheels = absl-py==1.4.0
#     exceptiongroup==1.1.2
#     execnet==2.0.2
#     # GPU:
#-    # exllama==0.0.13
#+    exllama==0.0.13
#     fastapi==0.100.0
#     feedparser==6.0.10
#     ffmpy==0.3.1
#@@ -123,9 +123,9 @@ pypi_wheels = absl-py==1.4.0
#     layoutparser==0.3.4
#     linkify-it-py==2.0.2
#     # CPU
#-    llama_cpp_python==0.1.73
#+    # llama_cpp_python==0.1.73
#     # GPU
#-    # llama-cpp-python-cuda==0.1.73
#+    llama-cpp-python-cuda==0.1.73
#     lm-dataformat==0.0.20
#     loralib==0.1.1
#     lxml==4.9.3