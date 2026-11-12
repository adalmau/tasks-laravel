<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index()
    {
        $tasks = Task::latest()->get();
        return view('tasks.index', compact('tasks'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => ['required','string','max:255'],
        ]);

        Task::create($data);
        return redirect()->route('tasks.index');
    }

    public function toggle(Task $task)
    {
        $task->update(['done' => ! $task->done]);
        return redirect()->route('tasks.index');
    }
}