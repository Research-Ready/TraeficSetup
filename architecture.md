# Value Chain Hackers Infrastructure Architecture

## Overview

This document outlines the architecture for the Value Chain Hackers infrastructure, designed to provide a robust and scalable platform for research in logistics, finance, and supply chain management. The infrastructure is based on Docker containers orchestrated with Docker Compose and Traefik as a reverse proxy and load balancer.

External IP:
94.142.241.156
 
Traefik: 10.0.4.10

```mermaid
graph TD
    subgraph "Internet"
        User[External User]
    end

    subgraph "Cloudflare (valuechainhackers.xyz)"
        DNS[DNS Wildcard Record: *]
    end

    subgraph "Your Datacenter"
        Public_IP[Public IP: 94.142.241.156]

        subgraph "Proxmox Host"
            Public_Interface[Public Interface: vmbr0]

            subgraph "Proxmox Firewall"
                Rule1[1. DNAT Rule <br> Rewrites Dst IP to 10.0.4.10]
                Rule2[2. FORWARD Rule <br> Allows packet from vmbr0 to vmbr4]
            end

            %% --- Network Layers ---
            subgraph "Network: vmbr4 (10.0.4.0/24) - Traefik"
                Traefik_LXC[Traefik LXC <br> 10.0.4.10]
            end

            subgraph "Network: vmbr5 (10.0.5.0/24) - Development"
                Dev_Services[Future Dev Services <br> e.g., app.dev.vch.xyz]
            end

            subgraph "Network: vmbr6 (10.0.6.0/24) - Test"
                Test_Services[Future Test Services <br> e.g., app.test.vch.xyz]
            end
            
            subgraph "Network: vmbr7 (10.0.7.0/24) - Acceptance"
                Acc_Services[Future Acc Services <br> e.g., app.acc.vch.xyz]
            end

            subgraph "Network: vmbr8 (10.0.8.0/24) - Production"
                Prod_Services[Future Prod Services <br> e.g., app.prod.vch.xyz]
            end
        end
    end

    %% --- Data Flow ---
    User -- "Requests a service URL" --> DNS
    DNS -- "Points to 94.142.241.156" --> Public_IP
    Public_IP --> Public_Interface
    Public_Interface -- "Packet arrives on host" --> Rule1
    Rule1 -- "Destination IP becomes 10.0.4.10" --> Rule2
    Rule2 -- "Packet forwarding is permitted" --> Traefik_LXC

    %% --- Intelligent Routing by Traefik ---
    subgraph "Traefik's Routing Logic"
      Traefik_LXC -- "Inspects Host: 'app.dev...'" --> Dev_Services
      Traefik_LXC -- "Inspects Host: 'app.test...'" --> Test_Services
      Traefik_LXC -- "Inspects Host: 'app.acc...'" --> Acc_Services
      Traefik_LXC -- "Inspects Host: 'app.prod...'" --> Prod_Services
    end
```

## Key Components

*   **Traefik:** Acts as the entry point for all external traffic, routing requests to the appropriate services based on hostnames and TLS certificates. (10.0.5.10)
*   **PostgreSQL:** A relational database used for storing structured data. It will be used to store financial data, research metadata, and application state. (10.0.5.11)
*   **Redis:** An in-memory data store used for caching and session management. (10.0.5.12)
*   **Nextcloud:** A self-hosted content collaboration platform for file sharing and synchronization. (10.0.5.13)
*   **JupyterHub:** A multi-user Jupyter Notebook server for interactive computing. (10.0.5.14)
*   **OpenBB Terminal:** A free, open-source alternative to the Bloomberg Terminal. (10.0.5.15)
*   **OR-Tools:** An open source software suite for operations research. (10.0.5.16)
*   **RStudio:** An integrated development environment for R statistical computing. (10.0.5.17)
*   **SUMO:** A microscopic traffic simulation suite. (10.0.5.18)
*   **InfluxDB:** A time-series database for storing and analyzing time-stamped data. (10.0.5.19)
*   **KNIME:** A no-code/low-code data analytics platform. (10.0.5.20)
*   **Orange:** An open source data visualization and analysis tool. (10.0.5.21)
*   **Octave:** A numerical computing environment compatible with MATLAB. (10.0.5.22)
*   **Scilab:** Another open source alternative to MATLAB. (10.0.5.23)
*   **JaamSim:** A discrete-event simulation software. (10.0.5.24)
*   **SimPy:** A Python framework for discrete-event simulation. (10.0.5.25)
*   **Mesa:** A Python framework for agent-based modeling. (10.0.5.26)
*   **Apache Spark:** A distributed computing engine for big data analysis. (10.0.5.27)
*   **Apache Airflow:** A workflow orchestrator for managing data pipelines. (10.0.5.28)
*   **Overleaf:** A web-based collaborative LaTeX editor. (10.0.5.29)
*   **Etherpad:** A real-time text editor for collaborative note-taking. (10.0.5.30)
*   **GitLab:** A self-hosted platform for code and project management. (10.0.5.31)
*   **Gitea:** A lightweight Git service. (10.0.5.32)
*   **Mattermost:** A self-hosted team messaging platform. (10.0.5.33)
*   **Work Adventure:** A virtual workspace for collaboration. (10.0.5.34)
*   **Focalboard:** An open-source project management tool. (10.0.5.35)
*   **Timefold:** A leading open source constraint solver. (10.0.5.36)
*   **Pyomo:** A Python toolkit for mathematical modeling. (10.0.5.37)
*   **GLPK:** GNU Linear Programming Kit for linear and integer programming. (10.0.5.38)
*   **QuantLib:** A comprehensive open-source C++ library for quantitative finance. (10.0.5.39)
*   **OpenBoxes:** An open source inventory and supply chain management system. (10.0.5.40)
*   **Odoo:** An open source enterprise resource planning system. (10.0.5.41)
*   **BorgBackup:** Secure and efficient backup solution. (10.0.5.42)
*   **LabPlot:** Scientific plotting and data analysis. (10.0.5.43)
*   **R:** Statistical computing and graphics language. (10.0.5.44)
*   **OpenWebUI:** Web UI for interacting with large language models. (10.0.5.45)
*   **Ollama:** Local LLM inference engine. (10.0.5.46)
*   **Crew A.I:** Collaboration platform for AI agents. (10.0.5.47)
*   **BigAgi:** Advanced AI tool for research and prototyping. (10.0.5.48)
*   **Ansible/Terraform:** Infrastructure as code for automation. (10.0.5.49)
*   **Quarto:** Scientific and technical publishing. (10.0.5.50)
*   **Logseq:** Knowledge management and note-taking. (10.0.5.51)
*   **Kile:** LaTeX editor for document preparation. (10.0.5.52)
*   **Chainforge:** Blockchain analysis. (10.0.5.53)
*   **Crawl A.I:** Web crawling and data scraping. (10.0.5.54)
*   **Kotaemon:** Chat with documents using RAG. (10.0.5.55)
*   **Cantor:** Interface for mathematical software. (10.0.5.56)
*   **KStars:** Astronomy software. (10.0.5.57)
*   **RKWard:** GUI for R programming. (10.0.5.58)
*   **KmPlot:** Mathematical function plotting. (10.0.5.59)
*   **Kalzium:** Periodic table of elements. (10.0.5.60)
*   **Step:** Interactive physics simulator. (10.0.5.61)
*   **Rocs:** Graph theory IDE. (10.0.5.62)

## Containerization and Traefik Coordination

*   **CKAN:** A data management system for providing open data. (10.0.5.63)
*   **Mayan EDMS:** A document management system. (10.0.5.64)
*   **Wiki.js:** A modern and lightweight wiki app. (10.0.5.65)
*   **OpenSearch:** A distributed search and analytics suite. (10.0.5.66)
*   **Open Semantic Search:** A semantic search engine. (10.0.5.67)
*   **Apache Tika:** A content analysis toolkit. (10.0.5.68)
*   **Archivematica:** A digital preservation system. (10.0.5.69)
*   **ArchiveBox:** A self-hosted archiving tool. (10.0.5.70)
*   **Dataverse:** A data repository platform. (10.0.5.71)
*   **Scrapy:** A fast and powerful scraping framework. (10.0.5.72)
*   **Apache NiFi:** A dataflow system. (10.0.5.73)
*   **Airbyte:** An open-source data integration platform. (10.0.5.74)
*   **OpenRefine:** A powerful tool for working with messy data. (10.0.5.75)
*   **Taguette:** A tool for qualitative data analysis. (10.0.5.76)
*   **Doccano:** A tool for text annotation. (10.0.5.77)
*   **Metabase:** An open-source business intelligence tool. (10.0.5.78)
*   **JupyterLab / Notebook:** An interactive development environment for notebooks. (10.0.5.79)
*   **RStudio Server:** A server version of RStudio. (10.0.5.80)
*   **Apache Zeppelin:** A web-based notebook for data exploration. (10.0.5.81)
*   **Overleaf Community Edition:** A collaborative LaTeX editor. (10.0.5.82)
*   **Voila (Jupyter Voilà):** A tool for turning Jupyter notebooks into interactive dashboards. (10.0.5.83)
*   **Grafana:** A data visualization and monitoring tool. (10.0.5.84)
*   **Apache Superset:** A modern data exploration and visualization platform. (10.0.5.85)
*   **Shiny Server (Open Source Edition):** A server for running Shiny applications. (10.0.5.86)

*   **Awesome AI - AI API**
*   **HuggingFace:** A collaboration platform for models, datasets, and applications. (10.0.5.87)
*   **CivitAI:** Explore and share Stable Diffusion models. (10.0.5.88)
*   **Mistral AI:** Open and portable generative AI. (10.0.5.89)
*   **Anthropic:** AI safety and research company. (10.0.5.90)
*   **Groq:** High-performance AI inference. (10.0.5.91)
*   **OpenAI:** Access to new AI models. (10.0.5.92)
*   **Perplexity:** AI-powered search. (10.0.5.93)
*   **OpenRouter:** Unified interface for LLMs. (10.0.5.94)
*   **Gemini API:** Access Google's largest AI model. (10.0.5.95)
*   **Cohere:** LLMs and RAG capabilities. (10.0.5.96)
*   **OctoAI:** Scale production applications on optimized models. (10.0.5.97)
*   **Anyscale:** AI workflow orchestration. (10.0.5.98)
*   **Stability AI:** Generative AI platform. (10.0.5.99)
*   **Lite LLM:** LLM inference with spend tracking. (10.0.5.100)

*   **Awesome AI - AI Cloud**
*   **Together AI:** Build and scale gen AI models. (10.0.5.101)
*   **Vertex AI:** Google's unified AI development platform. (10.0.5.102)
*   **Sagemaker:** Build and scale generative AI applications. (10.0.5.103)
*   **Azure OpenAI:** Access OpenAI models on Azure. (10.0.5.104)
*   **Rundiffusion:** Run Stable Diffusion in the cloud. (10.0.5.105)
*   **Replicate:** Deploy and scale open-source models. (10.0.5.106)
*   **Paperspace:** AI infrastructure on NVIDIA GPUs. (10.0.5.107)
*   **Bedrock:** Access foundation models on AWS. (10.0.5.108)
*   **Workers AI:** Run ML models on Cloudflare's network. (10.0.5.109)
*   **Scaleway:** European sovereign cloud for AI. (10.0.5.110)

*   **Awesome AI - Knowledge Manager**
*   **Anything LLM:** Chat with your documents using LLMs. (10.0.5.111)
*   **Docs GPT:** Ask questions about your documentation. (10.0.5.112)
*   **Quivr:** Your second brain, utilizes the power of GenerativeAI to be your personal assistant. (10.0.5.113)
*   **Chaindesk:** The no-code platform for building custom LLM Agents that provides a solution to quickly setup a semantic search system over your personal data. (10.0.5.114)
*   **Solid GPT:** Chat with your code repository, ask repository-level code questions, and discuss your requirements. (10.0.5.115)
*   **Examor:** Examor is a web application that allows you to take exams based on your knowledge notes. Let you really remember what you have learned and written. (10.0.5.116)
*   **Second Brain:** Second Brain AI Agents offer a way to seamlessly index, search and interact with all your contents, markdown files, videos, web pages, and PDFs. (10.0.5.117)
*   **Gerev:** Gerev is an AI-powered enterprise search engine that let you find any conversation, doc, or internal page in seconds. (10.0.5.118)
*   **PrivateGPT:** PrivateGPT is a production-ready AI project that allows you to ask questions about your documents using the power of Large Language Models (LLMs). (10.0.5.119)
*   **TxtAI:** txtAI is an all-in-one embeddings database for semantic search, LLM orchestration and language model workflows. (10.0.5.120)
*   **Swirl:** Swirl is an open source software that simultaneously searches multiple content sources and returns AI ranked results. (10.0.5.121)
*   **Danswer:** Ask Questions in natural language and get Answers backed by private sources. Connects to tools like Slack, GitHub, Confluence, etc. (10.0.5.122)

*   **Awesome AI - LLMs Eval**
*   **AlpacaEval:** An automatic evaluator for instruction-following language models. Human-validated, high-quality, cheap, and fast. (10.0.5.123)
*   **FastChat:** FastChat is a benchmark platform for large language models (LLMs) that features anonymous, randomized battles in a crowdsourced manner. (10.0.5.124)
*   **BigCode Eval:** BigCode Evaluation Harness is a framework for the evaluation of autoregressive code generation language models. (10.0.5.125)
*   **Promptfoo:** Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality. (10.0.5.126)

## LLMs Framework
*   **Unsloth:** Unsloth is an open-source framework which allow you to unslow finetuning for Large Language Models. (10.0.5.127)
*   **Pezzo:** Pezzo is an open-source, developer-first LLMOps platform designed to streamline prompt design, version management, instant delivery, and more. (10.0.5.128)
*   **Lunary:** Lunary is a production toolkit for LLMs. Observability, prompt management and evaluations. (10.0.5.129)
*   **Ludwig:** Ludwig is a low-code framework for building custom AI models like LLMs and other deep neural networks. (10.0.5.130)
*   **Langdroid:** Langdroid is an intuitive, lightweight, extensible and principled Python framework to easily build LLM-powered applications, from ex-CMU and UW-Madison researchers. (10.0.5.131)
*   **LangChain:** Langchain is aimed at assisting in the development of apps merging both LLMs and other sources of knowledge. (10.0.5.132)
*   **LLMware:** LLMware is a unified framework for developing LLM-based application patterns including Retrieval Augmented Generation (RAG). (10.0.5.133)
*   **LLM App:** LLM App is a production framework for building and serving AI applications and LLM-enabled real-time data pipelines. (10.0.5.134)
*   **Dify:** Dify allows you to deploy your own version of Assistants API and GPTs, based on any LLMs. (10.0.5.135)
*   **NeumAI:** Neum AI is a data platform that helps developers leverage their data to contextualize Large Language Models through Retrieval Augmented Generation (RAG). (10.0.5.136)
*   **DB-GPT:** DB-GPT is an open-source framework designed for the realm of large language models (LLMs) within the database field. (10.0.5.137)
*   **Flowise:** Flowise is a Drag & Drop UI to build your customized LLM automation flow. (10.0.5.138)

## LLMs Training
*   **Colossal AI:** Maximize the runtime performance of your large neural networks with distributed techniques of Colossal-AI. (10.0.5.139)
*   **Megatron LM:** Megatron is a large, powerful transformer developed by the Applied Deep Learning Research team at NVIDIA. (10.0.5.140)
*   **DeepSpeed:** DeepSpeed is a deep learning optimization library that makes distributed training and inference easy, efficient, and effective. (10.0.5.141)

## Vector Database
*   **MindsDB:** MindsDB's AI SQL Server enables developers to build AI tools that need access to real-time data to perform their tasks. (10.0.5.142)
*   **Weaviate:** Weaviate is an open source vector database that is robust, scalable, cloud-native, and fast. (10.0.5.143)
*   **Milvus:** Milvus is an open-source vector database built to power embedding similarity search and AI applications. (10.0.5.144)
*   **FAISS:** (10.0.5.145)
*   **PostgreSQL + PGVector:** (10.0.5.146)
*   **Qdrant:** (10.0.5.147)

## LLMs (Models):
*   **LLaMA:** (10.0.5.148)
*   **Mistral:** (10.0.5.149)
*   **Qwen:** (10.0.5.150)
*   **Phi:** (10.0.5.151)
*   **Gemma:** (10.0.5.152)

## Frontend / UI:
*   **Next.js:** (10.0.5.153)
*   **Streamlit:** (10.0.5.154)

## Embeddings & RAG:
*   **Nomic:** (10.0.5.155)
*   **JinaAI:** (10.0.5.156)
*   **Cognito:** (10.0.5.157)
*   **LLMAware:** (10.0.5.158)

## Backend & Model Orchestration:
*   **FastAPI:** (10.0.5.159)
*   **LangChain:** (10.0.5.160)
*   **Netflix Metaflow:** (10.0.5.161)
*   **Ollama:** (10.0.5.162)
*   **Huggingface:** (10.0.5.163)

## Additional Tools:
*   **n8n:** Low-code platform with over 400 integrations and advanced AI components. (10.0.5.164)
*   **Supabase:** Open source database as a service - most widely used database for AI agents. (10.0.5.165)
*   **Open WebUI:** ChatGPT-like interface to privately interact with your local models and N8N agents. (10.0.5.166)
*   **Flowise:** No/low code AI agent builder that pairs very well with n8n. (10.0.5.167)
*   **Neo4j:** Knowledge graph engine that powers tools like GraphRAG, LightRAG, and Graphiti. (10.0.5.168)
*   **SearXNG:** Open source, free internet metasearch engine which aggregates results from up to 229 search services. Users are neither tracked nor profiled, hence the fit with the local AI package. (10.0.5.169)
*   **Langfuse:** Open source LLM engineering platform for agent observability. (10.0.5.170)
