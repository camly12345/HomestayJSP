<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title != null ? title : 'Núi Homestay - Yên Bình Giữa Lòng Cố Đô'}</title>
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #10b981;
            --primary-hover: #059669;
            --dark-color: #0f172a;
            --light-bg: #f8fafc;
            --card-border: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: #334155;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        main {
            flex: 1;
        }
        .navbar-brand {
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #0f172a !important;
        }
        .hero-banner {
            position: relative;
            background: linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.65)), url('${pageContext.request.contextPath}/images/background.jpg') center/cover no-repeat;
            color: white;
            padding: 100px 0 130px;
            text-align: center;
        }
        .search-overlap-card {
            margin-top: -65px;
            position: relative;
            z-index: 10;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid var(--card-border);
        }
        .homestay-card {
            border: 1px solid var(--card-border);
            border-radius: 14px;
            overflow: hidden;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            background: white;
        }
        .homestay-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.09);
        }
        .room-badge {
            background-color: #ecfdf5;
            color: #059669;
            font-weight: 600;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 0.8rem;
        }
        .btn-success-custom {
            background-color: #10b981;
            border-color: #10b981;
            color: white;
            font-weight: 600;
            border-radius: 8px;
            padding: 8px 18px;
        }
        .btn-success-custom:hover {
            background-color: #059669;
            border-color: #059669;
            color: white;
        }
        .badge-available {
            background-color: #dcfce7;
            color: #166534;
        }
        .badge-occupied {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .badge-maintenance {
            background-color: #fef3c7;
            color: #92400e;
        }
    </style>
</head>
<body>
