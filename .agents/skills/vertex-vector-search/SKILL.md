---
name: vertex-vector-search
description: "Build semantic search, RAG pipelines, and recommendation systems using Google Cloud Vertex AI Vector Search (formerly Matching Engine). Use this skill when the user wants to implement vector similarity search, hybrid search (dense + sparse), streaming index updates, or integrate Vector Search into a RAG or agent pipeline. Also use when the user mentions Vertex AI Vector Search, ScaNN, embeddings search, nearest neighbor search, or Matching Engine."
---

# Vertex AI Vector Search

Enterprise-grade vector similarity search on Google Cloud, powered by Google's ScaNN algorithm — the same tech behind Google Search, YouTube, and Google Play.

## Docs
https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/vector-search/overview

## Key Concepts

| Term | Meaning |
|------|---------|
| **Embedding** | Vector representing semantic meaning of data |
| **Index** | Deployed collection of vectors for similarity search |
| **Recall** | % of actual nearest neighbors returned |
| **Restrict** | Boolean filtering to limit search to index subsets |
| **Dense embedding** | Semantic search (meaning-based) |
| **Sparse embedding** | Keyword/lexical search |
| **Hybrid search** | Combines dense + sparse for best of both |

## Use Cases

- **RAG** — retrieve relevant context chunks for LLM prompts
- **Semantic search** — document and multimodal search
- **Recommendations** — product/content personalization
- **Real-time analytics** — streaming data ingestion + search

## Setup

```python
from google.cloud import aiplatform

aiplatform.init(project="YOUR_PROJECT", location="us-central1")

# Create an index
my_index = aiplatform.MatchingEngineIndex.create_tree_ah_index(
    display_name="my-index",
    contents_delta_uri="gs://my-bucket/embeddings/",
    dimensions=768,
    approximate_neighbors_count=150,
)

# Deploy index to endpoint
my_index_endpoint = aiplatform.MatchingEngineIndexEndpoint.create(
    display_name="my-endpoint",
    public_endpoint_enabled=True,
)
my_index_endpoint.deploy_index(index=my_index, deployed_index_id="my_deployed_index")
```

## Query

```python
# Find nearest neighbors
response = my_index_endpoint.find_neighbors(
    deployed_index_id="my_deployed_index",
    queries=[query_embedding],
    num_neighbors=10,
)
```

## Streaming Updates (real-time)

```python
# Upsert embeddings without full rebuild
my_index.upsert_datapoints(datapoints=[
    aiplatform.IndexDatapoint(
        datapoint_id="doc_001",
        feature_vector=[0.1, 0.2, ...],
        restricts=[aiplatform.IndexDatapoint.Restriction(
            namespace="category", allow_list=["tech"]
        )]
    )
])
```

## Hybrid Search (dense + sparse)

```python
response = my_index_endpoint.find_neighbors(
    deployed_index_id="my_deployed_index",
    queries=[query_embedding],
    sparse_queries=[sparse_query_embedding],  # adds keyword matching
    num_neighbors=10,
)
```

## Filtering with Restricts

```python
# Only search within a subset
response = my_index_endpoint.find_neighbors(
    deployed_index_id="my_deployed_index",
    queries=[query_embedding],
    num_neighbors=10,
    filter=[aiplatform.Namespace("category", ["tech", "science"])],
)
```

## Deployment Options

| Option | Use Case |
|--------|---------|
| Public endpoint | External-facing apps |
| Private Service Connect (PSC) | VPC-isolated, private |
| VPC peering | Custom network topology |

## Framework Integrations

```python
# LangChain
from langchain_google_vertexai import VectorSearchVectorStore

vectorstore = VectorSearchVectorStore.from_components(
    project_id="YOUR_PROJECT",
    region="us-central1",
    gcs_bucket_name="my-bucket",
    index_id=my_index.name,
    endpoint_id=my_index_endpoint.name,
    embedding=embeddings,
)

# LlamaIndex — use VertexAIVectorStore similarly
```

## Pricing

- VM hosting for index endpoint (per vCPU/hour)
- Index build/update costs
- Minimal setup: ~$100/month
- Use pricing calculator: https://cloud.google.com/products/calculator
