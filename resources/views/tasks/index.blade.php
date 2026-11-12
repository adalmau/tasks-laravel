<!doctype html>
<html lang="ca">
<head>
  <meta charset="utf-8">
  <title>Task Demo</title>
  <!-- Per simplicitat, style mínim inline -->
  <style>
    body { font-family: system-ui, sans-serif; max-width: 720px; margin: 2rem auto; }
    form { margin: 1rem 0; display: flex; gap: .5rem; }
    input[type=text]{ flex:1; padding:.5rem; }
    button { padding:.5rem 1rem; }
    ul{list-style:none; padding:0; margin:1rem 0;}
    li{ display:flex; justify-content:space-between; border:1px solid #ddd; padding:.5rem; margin:.25rem 0; border-radius: .375rem;}
    .done { text-decoration: line-through; color: #666; }
  </style>
</head>
<body>
  <h1>📋 Llista de tasques</h1>

  <form method="POST" action="{{ route('tasks.store') }}">
    @csrf
    <input type="text" name="title" placeholder="Nova tasca..." required>
    <button type="submit">Afegir</button>
  </form>

  @error('title')
    <p style="color:#c00">{{ $message }}</p>
  @enderror

  <ul>
    @forelse($tasks as $task)
      <li>
        <span class="{{ $task->done ? 'done' : '' }}">{{ $task->title }}</span>
        <form method="POST" action="{{ route('tasks.toggle', $task) }}">
          @csrf @method('PATCH')
          <button type="submit">{{ $task->done ? 'Desfer' : 'Fet' }}</button>
        </form>
      </li>
    @empty
      <li>No hi ha tasques encara.</li>
    @endforelse
  </ul>
</body>
</html>