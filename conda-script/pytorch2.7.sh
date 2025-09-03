conda create -y -p /conda_envs/pytorch2.7 python=3.11
conda activate /conda_envs/pytorch2.7
#conda install cuda -c nvidia/label/cuda-12.9.0
conda install conda-forge::openexr==3.3.5
conda install conda-forge::pytorch==2.7.1
conda install conda-forge::opencv==4.12.0
conda install anaconda::scikit-image==0.25.0


pip install diffusers==0.35.1
pip install xformers==0.0.32.post2
pip install skylibs==0.7.7