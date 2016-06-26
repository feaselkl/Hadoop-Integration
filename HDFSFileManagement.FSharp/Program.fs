open System
open Microsoft.Hadoop.MapReduce
open FSharp.Data
open FSharp.Data.SqlClient

[<Literal>]
let connectionString = 
    @"Data Source=LOCALHOST;Initial Catalog=OOTP;Integrated Security=True"

type InsertSecondBaseman = 
    SqlCommandProvider<"INSERT INTO Player.SecondBasemen(FirstName, LastName, Age, Bats, Throws) VALUES(@FirstName, @LastName, @Age, @Bats, @Throws)", connectionString>
 
[<EntryPoint>]
let main argv = 
    //Connect to the cluster.  Replace the URI with your local machine name.
    //This is a sandbox, so there is no password.  Set a password in your real environment, okay?
    let clusterURI = new Uri("http://192.168.172.149:50070")
    let cluster = Hadoop.Connect(clusterURI, "admin", null);

    //Part 1:  bring a file down
    let hdfsPath = "/tmp/ootp/secondbasemen.csv"
    let localPath = "C:\\Temp\\SecondBasemen.csv"
    cluster.StorageSystem.CopyToLocal(hdfsPath, localPath)
    printfn "%A copied down to %A" hdfsPath localPath

    //Part 1b:  write the file contents into SQL Server
    let secondbasemen = System.IO.File.ReadAllLines(localPath)
    
    let conn = new System.Data.SqlClient.SqlConnection(connectionString)
    conn.Open()
    let tran = conn.BeginTransaction()
    secondbasemen |>
        Array.filter (fun x -> x.Length > 0) |>
        Array.iter(
            fun x -> let s = x.Split(',')
                     use insert = InsertSecondBaseman.Create(conn, tran)
                     insert.Execute(s.[0], s.[1], Convert.ToInt32(s.[2]), s.[3], s.[4]) |> ignore
            )
    tran.Commit()
    conn.Close()
    printfn "Successfully loaded Player.SecondBasemen."
    
    //Part 2:  send a file up
    let hdfsPath = "/tmp/ootp/PitchingRatings.csv"
    let localPath = "C:\\Temp\\Pitching\\PitchingRatings.csv"
    cluster.StorageSystem.CopyFromLocal(localPath, hdfsPath)
    printfn "%A sent up to %A" localPath hdfsPath    

    let ok = Console.ReadLine()
    0 // return an integer exit code
