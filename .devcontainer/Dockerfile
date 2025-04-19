FROM danteev/texlive

# Install tools
RUN pip install arxiv-latex-cleaner==0.1.* pdflinkchecker-cli==0.2.* --break-system-packages && \
sed -i 's/^\(.*Optional..arguments.*\)/#\1/' /usr/local/texlive/2024/texmf-dist/chktex/chktexrc

RUN apt-get update && apt-get install -y bash-completion
