defmodule TodomvcWeb.TodoLive do
  use TodomvcWeb, :live_view

  #socket é uma representação do websocket que temos na página
  #de forma simplificada, o socket representa o estado do usuário atual
  #é possível colocar dados no socket utilizando assigns
  def mount(_params, _session, socket)do
    todos = [
      #podemos colocar interrogações no nome das variaveis
      %{message: "A", completed?: true},
      %{message: "B", completed?: false},
      %{message: "C", completed?: false},
      %{message: 12 , completed?: false}
    ]
    socket =
      socket
      |> assign(:todos,todos)
      |>assign(:filtered_todos, todos)
      |>assign(:filter, "all")
    {:ok, socket}
  end


  #ENTENDENDO HANDLE EVENT
  #todos os assigns ficam salvos dentro do socket, então usamos essa sintaxe de pontos para acessar
  #para chegarmou ao counter que declaramos no mount fazemos: socket.assign.counter

  def handle_event("change_filter", %{"filter" => filter}, socket) do
      socket =
        socket
        |> assign(:filter, filter)
        |> assign(:filtered_todos,
        Enum.filter(socket.assigns.todos, fn x ->
          case filter do
            "all" -> true
            "active" -> not x.completed?
            "finished" -> x.completed?
          end
        end)
        )
        {:noreply, socket}
  end

  def handle_event("todo_form_submit", %{"new_todo" => %{"message" => message}}, socket) do
    new_todo = %{message: message, completed?: false}

    socket =
      socket
      |> assign(:todos, [new_todo] ++ socket.assigns.todos)
      {:noreply, socket}
  end
#declarando um componente
  def filter_button(assigns) do
    ~H"""
     <button
      phx-click="change_filter"
      phx-value-filter={@filter}
      class="bg-slate-500 px-4 py-2 rounded-md hover:bg-slate-700 transition-all"
     >
      <%= @label%>
      </button>
    """
  end

  #ENTENDENDO A FUNÇÃO RENDER
  #declaramos aqui um render, que é o que diz para o phoenix como queremos renderizar o HTML
  #live_view é uma lib dentro do phoenix para criar front end interativo
  #muito similar ao react! A diferença é que a liveview roda no server e nao no virtualDOM como o JS
  #parametro assigns
  #escrevemos HTML com o sigil ~H""""""
  #podemos remover o render do arquivo principal (o que irei fazer), para isso basta criar um arquivo
  #com o mesmo nome desse aqui e utilizar a extensão.html.heex
  #heex é a marcação de HTML do phoenix, a vantagem é que ele valida o HTML

 #* def render(assigns) do
  #  ~H"""
   # <p>Hello World</p>
    #"""
  #end

end
