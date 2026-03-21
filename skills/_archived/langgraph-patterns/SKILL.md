---
name: langgraph-patterns
description: LangChain & LangGraph core patterns and best practices.
origin: ECC
---
# LangGraph Core Patterns
- **Architecture**: Use `StateGraph` for orchestration. Define explicit typed `State` classes using `TypedDict` or `Pydantic`.
- **Chains**: NEVER use legacy `Chain` classes. ALWAYS use LCEL (LangChain Expression Language) with the `|` pipe operator.
- **Tools**: Bind tools to LLMs using `.bind_tools()`. Use `ToolNode` to execute them.
- **Structured Output**: Use `.with_structured_output(PydanticModel)` to enforce clean data extraction.
- **Debugging**: Require `LANGCHAIN_TRACING_V2=true` and `LANGCHAIN_API_KEY` in `.env` for LangSmith.
- **Docs**: If hitting API errors, `defuddle` official docs (`python.langchain.com` or `langchain-ai.github.io/langgraph`) before proceeding. LangChain changes rapidly.

## Vibe Coding Boilerplate
Always start LangGraph agents with this robust `StateGraph` structure:
```python
from typing import Annotated, TypedDict
from langchain_core.messages import BaseMessage
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages
from langchain_anthropic import ChatAnthropic

# 1. State Definition (Message reducer is critical)
class AgentState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]
    # Add custom state variables here (e.g., extracted_data: str)

# 2. Node Definitions
def agent_node(state: AgentState):
    llm = ChatAnthropic(model="claude-3-5-sonnet-latest")
    # Bind tools here if needed: llm = llm.bind_tools(tools)
    response = llm.invoke(state["messages"])
    # Return MUST be a dict updating the state
    return {"messages": [response]} 

# 3. Conditional Edges (Routing)
def should_continue(state: AgentState) -> str:
    last_msg = state["messages"][-1]
    if last_msg.tool_calls:
        return "tools"
    return END

# 4. Graph Construction
builder = StateGraph(AgentState)
builder.add_node("agent", agent_node)
# builder.add_node("tools", ToolNode(tools)) # If using tools

builder.add_edge(START, "agent")
# builder.add_conditional_edges("agent", should_continue, ["tools", END])
# builder.add_edge("tools", "agent")

# 5. Compilation
graph = builder.compile()
# Usage: graph.invoke({"messages": [("user", "Hello!")]})
```
