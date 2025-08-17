namespace ahmet;
public class Test
{
    public static void Main()
    {
        int x, y;
        testmetgod(out x, out y);
        int sum = x + y;
        Console.WriteLine(sum); // Print the sum of x + y
        Name.ali();

    }

    private static void testmetgod(out int x, out int y)
    {
        x = 5;
        y = 6;
        int g = 5;
    }

    public void deneme()
    {
        Name ahmet = new Name();
        ahmet.Name = "ahmet";
    }
}


