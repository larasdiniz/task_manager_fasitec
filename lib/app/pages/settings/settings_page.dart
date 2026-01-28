// lib/app/pages/settings/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/extensions/size_extensions.dart';
import 'package:task_manager/app/core/ui/extensions/text_style_extensions.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart';
import 'package:task_manager/app/core/ui/theme/theme_manager.dart';
import 'package:task_manager/app/core/utils/router_name_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _syncEnabled = false;

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouterNameUtils.getHomePage);
  }

  void _navigateToCategories(BuildContext context) {
    // Implementar navegação para categorias quando tiver a página
  }

  void _navigateToGoals(BuildContext context) {
    // Implementar navegação para metas quando tiver a página
  }

  void _navigateToStatistics(BuildContext context) {
    // Implementar navegação para estatísticas quando tiver a página
  }

  void _navigateToSettings(BuildContext context) {
    // Já está na página de configurações
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Configurações',
          style: TextStyle().largeText.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.percentWidth(0.05)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção Aparência
              _buildSectionTitle('Aparência'),
              _buildSettingCard(
                title: 'Tema',
                subtitle: themeManager.themeMode == ThemeMode.dark 
                    ? 'Escuro' 
                    : themeManager.themeMode == ThemeMode.light 
                        ? 'Claro' 
                        : 'Sistema',
                trailing: Switch(
                  value: themeManager.isDark,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    themeManager.toggleTheme();
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Seção Notificações
              _buildSettingCard(
                title: 'Notificações',
                subtitle: _notificationsEnabled ? 'Ativadas' : 'Desativadas',
                trailing: Switch(
                  value: _notificationsEnabled,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Seção Sincronização
              _buildSettingCard(
                title: 'Sincronização em Nuvem',
                subtitle: _syncEnabled ? 'Ativada' : 'Desativada',
                trailing: Switch(
                  value: _syncEnabled,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      _syncEnabled = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Seção Aplicativo
              _buildSectionTitle('Aplicativo'),
              _buildSettingItem(
                title: 'Sobre o App',
                icon: Icons.info_outline,
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _buildSettingItem(
                title: 'Política de Privacidade',
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  // Navegar para política de privacidade
                },
              ),
              _buildSettingItem(
                title: 'Termos de Uso',
                icon: Icons.description_outlined,
                onTap: () {
                  // Navegar para termos de uso
                },
              ),

              const SizedBox(height: 30),

              // Botão Limpar Dados
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showClearDataDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.error),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Limpar Todos os Dados',
                    style: TextStyle().mediumText.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Versão do App
              Center(
                child: Text(
                  'Task Manager v1.0.0',
                  style: TextStyle().smallText.copyWith(
                    color: isDark ? colors.textSecondaryDark : colors.textSecondaryLight, // ✅
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? colors.darkGray : colors.lightGray, // ✅
              width: 0.5,
            ),
          ),
          color: isDark ? colors.darkSurface : colors.lightSurface, // ✅
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.task, 'Tarefas', false, _navigateToHome),
            _buildNavItem(Icons.category, 'Categorias', false, _navigateToCategories),
            _buildNavItem(Icons.flag, 'Metas', false, _navigateToGoals),
            _buildNavItem(Icons.bar_chart, 'Estatísticas', false, _navigateToStatistics),
            _buildNavItem(Icons.settings, 'Config', true, _navigateToSettings),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle().mediumText.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: isDark ? colors.cardBackgroundDark : colors.cardBackgroundLight, // ✅
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? colors.cardBorderDark : colors.cardBorderLight, // ✅
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle().mediumText.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: TextStyle().smallText.copyWith(
                  color: isDark ? colors.textSecondaryDark : colors.textSecondaryLight, // ✅
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle().mediumText.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon, 
    String label, 
    bool isActive,
    Function(BuildContext) onTap,
  ) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary; 
    final inactiveColor = isDark ? colors.textSecondaryDark : colors.textSecondaryLight; // ✅

    return GestureDetector(
      onTap: () => onTap(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle().smallText.copyWith(
              fontSize: 12.sp,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Sobre o Task Manager',
          style: TextStyle().mediumText.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Aplicativo de gerenciamento de tarefas desenvolvido para organizar suas atividades diárias de forma eficiente.\n\nVersão: 1.0.0',
          style: TextStyle().smallText.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle().smallText.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Limpar Todos os Dados',
          style: TextStyle().mediumText.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Tem certeza que deseja limpar todos os dados do aplicativo? Esta ação não pode ser desfeita.',
          style: TextStyle().smallText.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle().smallText.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Limpar dados
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Dados limpos com sucesso'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Limpar',
              style: TextStyle().smallText.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}