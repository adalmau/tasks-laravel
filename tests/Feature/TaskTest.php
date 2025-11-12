<?php

namespace Tests\Feature;

use App\Models\Task;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TaskTest extends TestCase
{
    use RefreshDatabase;

    public function test_the_homepage_loads()
    {
        $this->get('/')->assertStatus(200)->assertSee('Llista de tasques');
    }

    public function test_we_can_create_a_task()
    {
        $response = $this->post('/tasks', ['title' => 'Provar CI']);
        $response->assertRedirect('/');
        $this->assertDatabaseHas('tasks', ['title' => 'Provar CI', 'done' => false]);
    }

    public function test_we_can_toggle_a_task()
    {
        $task = Task::create(['title' => 'Tasca', 'done' => false]);

        // Comprova que la tasca inicialment no està feta
        $this->assertFalse($task->done);

        $this->patch("/tasks/{$task->id}/toggle")->assertRedirect('/');

        // Actualitza la tasca
        $task = $task->fresh();

        //vull saber si el camp done és 1 o 0 a la base de dades
        $this->assertDatabaseHas('tasks', ['id' => $task->id, 'done' => true]);
    }
}