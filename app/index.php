<html>

<head>
<title>Exemplo PHP</title>
</head>
<body>

<?php
ini_set("display_errors", 1);
header('Content-Type: text/html; charset=iso-8859-1');

echo 'Versao Atual do PHP: ' . phpversion() . '<br>';

// Carregar configurações das variáveis de ambiente
$servername = $_ENV['DB_HOST'] ?? 'localhost';
$username = $_ENV['DB_USER'] ?? 'root';
$password = $_ENV['DB_PASS'] ?? '';
$database = $_ENV['DB_NAME'] ?? 'meubanco';

// Criar conexão com PDO
try {
    $dsn = "mysql:host=$servername;dbname=$database;charset=utf8mb4";
    $link = new PDO($dsn, $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]);
    echo "Conexão com banco de dados estabelecida com sucesso!<br><br>";
} catch (PDOException $e) {
    echo "Erro na conexão: " . $e->getMessage();
    exit();
}

$valor_rand1 = rand(1, 999);
$valor_rand2 = strtoupper(substr(bin2hex(random_bytes(4)), 1));
$host_name = gethostname();

// Preparar statement com PDO
$query = "INSERT INTO dados (Nome, Sobrenome, Endereco, Cidade, Host) 
          VALUES (:nome, :sobrenome, :endereco, :cidade, :host)";

try {
    $stmt = $link->prepare($query);
    $stmt->execute([
        ':nome' => $valor_rand2,
        ':sobrenome' => $valor_rand2,
        ':endereco' => $valor_rand2,
        ':cidade' => $valor_rand2,
        ':host' => $host_name
    ]);
    echo "✅ Novo registro inserido com sucesso!<br>";
    echo "ID: " . $link->lastInsertId() . "<br>";
} catch (PDOException $e) {
    echo "❌ Erro: " . $e->getMessage();
}

echo "<br><b>Dados Inseridos:</b><br>";
echo "Host: " . $host_name . "<br>";
echo "Timestamp: " . date('Y-m-d H:i:s') . "<br>";

// Listar últimos registros
echo "<br><b>Últimos 5 Registros:</b><br>";
try {
    $result = $link->query("SELECT AlunoID, Nome, Host, DataCriacao FROM dados ORDER BY AlunoID DESC LIMIT 5");
    echo "<table border='1'>";
    echo "<tr><th>ID</th><th>Nome</th><th>Host</th><th>Data</th></tr>";
    while ($row = $result->fetch()) {
        echo "<tr><td>" . $row['AlunoID'] . "</td><td>" . $row['Nome'] . "</td><td>" . $row['Host'] . "</td><td>" . $row['DataCriacao'] . "</td></tr>";
    }
    echo "</table>";
} catch (PDOException $e) {
    echo "Erro ao listar: " . $e->getMessage();
}

// Fechar conexão
$link = null;
?>
</body>
</html>
