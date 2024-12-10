% Crear figura
figure;
hold on;

% Pesos inversamente proporcionales a las incertidumbres cuadradas
weights = 1 ./ (incm.^2); % Usamos incertidumbres en m (puedes ajustar según corresponda)

% Ajuste ponderado: Usamos un sistema de ecuaciones lineales para ponderar
W = diag(weights); % Matriz diagonal de pesos
X = [do, ones(size(do))]; % Matriz de diseño para modelo lineal (pendiente e intercepto)
beta = (X' * W * X) \ (X' * W * m); % Resolviendo con mínimos cuadrados ponderados
p(1) = beta(1); % Pendiente
p(2) = beta(2); % Intercepto

% Calcular valores ajustados
y_fit = X * beta; % Valores ajustados
residuals = m - y_fit; % Residuos
S = sqrt(sum((W * residuals).^2) / (length(m) - 2)); % Error estándar del ajuste

% Calcular incertidumbres de la pendiente y el intercepto
cov_matrix = inv(X' * W * X); % Matriz de covarianza
slope_error = sqrt(cov_matrix(1, 1)); % Incertidumbre en la pendiente
intercept_error = sqrt(cov_matrix(2, 2)); % Incertidumbre en el intercepto

% Mostrar resultados
fprintf('Pendiente (m): %.4f ± %.4f\n', p(1), slope_error);
fprintf('Intersección (b): %.4f ± %.4f\n', p(2), intercept_error);

% Gráfica con barras de error en ambas direcciones
errorbar(do, m, incm, incm, incdo, incdo, 's', 'Color', [0, 0, 1], ...
    'MarkerSize', 6, 'MarkerFaceColor', [0, 0, 1], ...
    'DisplayName', sprintf('Datos: 1/si(1/so) = (%.4f ± %.4f)1/so + (%.4f ± %.4f)', ...
    p(1), slope_error, p(2), intercept_error));

% Línea de ajuste (sin incluirla en la leyenda)
plot(do, y_fit, 'Color', [0, 0, 1], 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Etiquetas y formato
xlabel('1/so [mm^{-1}]', 'FontSize', 12); % Cambia el eje x a la nueva variable
ylabel('1/si [mm^{-1}]', 'FontSize', 12); % Cambia el eje y a la nueva variable
legend('Location', 'northwest', 'FontSize', 10);
grid on;
set(gca, 'FontSize', 12);

hold off;
