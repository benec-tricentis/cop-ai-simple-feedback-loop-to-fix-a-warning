namespace TodoApp;

public class TodoItem
{
    public required string Title { get; set; }
    public string Description { get; set; }
    public bool IsCompleted { get; set; }
    public DateTime CreatedAt { get; set; }

    private int _internalId = 0;

    public void MarkComplete()
    {
        IsCompleted = true;
    }

    public override string ToString()
    {
        var status = IsCompleted ? "[x]" : "[ ]";
        return $"{status} {Title}";
    }
}
