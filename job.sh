#!/bin/bash
#SBATCH --account=def-oforion          # Account name
#SBATCH --job-name=ghosh_test          # Job name
#SBATCH --nodes=1                      # Number of nodes
#SBATCH --ntasks-per-node=4            # Number of tasks per node
#SBATCH --mem=32G                      # Total memory per node
#SBATCH --time=00:30:00                # Max runtime (30 minutes)
#SBATCH --output=ghosh_test.out        # Standard output
#SBATCH --error=ghosh_test.err         # Standard error

# Load Apptainer module
module load apptainer

# Run commands inside the container
apptainer exec /home/pasha77/projects/def-oforion/pasha77/moose.sif bash -c '
  cd /home/pasha77/projects/def-oforion/pasha77/projects && \
  source env-setting && \
  export PATH=/opt/miniforge/bin:/opt/moose/bin:$PATH && \
  export LD_LIBRARY_PATH=/opt/wasp/lib:$LD_LIBRARY_PATH && \
  source /opt/miniforge3/etc/profile.d/conda.sh && \
  conda activate moose && \
  pip install --user pyyaml && \
  cd /home/pasha77/projects/def-oforion/pasha77/projects/ghosh && \
  make -j4
'

# Run the simulation with parallel tasks using srun
srun apptainer exec /home/pasha77/projects/def-oforion/pasha77/moose.sif /home/pasha77/projects/def-oforion/pasha77/projects/ghosh/ghosh-opt -i test1.i
