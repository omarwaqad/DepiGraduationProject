import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:delleni_app/app/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
	SettingsPage({super.key});

	final SettingsController controller = Get.put(SettingsController());

	@override
	Widget build(BuildContext context) {
		final screenWidth = MediaQuery.of(context).size.width;
		final isSmallScreen = screenWidth < 360;

		return Scaffold(
			backgroundColor: Colors.grey[50],
			body: SafeArea(
				child: Obx(() {
					if (controller.isLoading.value) {
						return const Center(
							child: CircularProgressIndicator(
								color: Color(0xFF2E9B6F),
							),
						);
					}

					return SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.end,
							children: [
								Container(
									width: double.infinity,
									decoration: const BoxDecoration(
										gradient: LinearGradient(
											colors: [Color(0xFF2E9B6F), Color(0xFF43B883)],
											begin: Alignment.topLeft,
											end: Alignment.bottomRight,
										),
									),
									padding: EdgeInsets.fromLTRB(
										screenWidth * 0.05,
										MediaQuery.of(context).padding.top + 20,
										screenWidth * 0.05,
										24,
									),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.end,
										children: [
											Row(
												children: [
													IconButton(
														onPressed: () => Get.back(),
														icon: const Icon(Icons.arrow_back, color: Colors.white),
													),
													const SizedBox(width: 8),
													Text(
														'إعدادات الحساب',
														style: TextStyle(
															color: Colors.white,
															fontSize: isSmallScreen ? 20 : 24,
															fontWeight: FontWeight.bold,
														),
														textAlign: TextAlign.right,
													),
												],
											),
											const SizedBox(height: 12),
											Text(
												'.حدّث اسمك أو رقم هاتفك وسيتم حفظهما في حسابك',
												style: TextStyle(
													color: Colors.white.withOpacity(0.9),
													fontSize: isSmallScreen ? 12 : 14,
												),
											textAlign: TextAlign.right,
											),
										],
									),
								),

								Padding(
									padding: EdgeInsets.symmetric(
										horizontal: screenWidth * 0.05,
										vertical: 24,
									),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.end,
										children: [
											_buildInputField(
												label: 'الاسم الأول',
												controller: controller.firstNameCtrl,
												isSmallScreen: isSmallScreen,
											),
											const SizedBox(height: 14),
											_buildInputField(
												label: 'اسم العائلة',
												controller: controller.lastNameCtrl,
												isSmallScreen: isSmallScreen,
											),
											const SizedBox(height: 14),
											_buildInputField(
												label: 'رقم الهاتف',
												controller: controller.phoneCtrl,
												keyboardType: TextInputType.phone,
												isSmallScreen: isSmallScreen,
											),

											const SizedBox(height: 24),
											SizedBox(
												width: double.infinity,
												child: ElevatedButton(
													style: ElevatedButton.styleFrom(
														backgroundColor: const Color(0xFF2E9B6F),
														padding: EdgeInsets.symmetric(
															vertical: isSmallScreen ? 12 : 14,
														),
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(12),
														),
													),
													onPressed: controller.isSaving.value
															? null
															: () => controller.saveChanges(),
													child: controller.isSaving.value
															? const SizedBox(
																	height: 18,
																	width: 18,
																	child: CircularProgressIndicator(
																		strokeWidth: 2,
																		color: Colors.white,
																	),
																)
															: Text(
																	'حفظ التغييرات',
																	style: TextStyle(
																		color: Colors.white,
																		fontSize: isSmallScreen ? 14 : 16,
																		fontWeight: FontWeight.bold,
																	),
																),
												),
											),
										],
									),
								),
							],
						),
					);
				}),
			),
		);
	}

	Widget _buildInputField({
		required String label,
		required TextEditingController controller,
		TextInputType keyboardType = TextInputType.text,
		required bool isSmallScreen,
	}) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				Text(
					label,
					style: TextStyle(
						fontSize: isSmallScreen ? 13 : 15,
						fontWeight: FontWeight.w600,
						color: Colors.grey[800],
					),
					textAlign: TextAlign.right,
				),
				const SizedBox(height: 8),
				TextField(
					controller: controller,
					keyboardType: keyboardType,
					textAlign: TextAlign.right,
					decoration: InputDecoration(
						filled: true,
						fillColor: Colors.white,
						contentPadding: EdgeInsets.symmetric(
							horizontal: isSmallScreen ? 12 : 14,
							vertical: isSmallScreen ? 12 : 14,
						),
						border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(12),
							borderSide: BorderSide(color: Colors.grey[300]!),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(12),
							borderSide: BorderSide(color: Colors.grey[300]!),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(12),
							borderSide: const BorderSide(color: Color(0xFF2E9B6F), width: 1.5),
						),
					),
				),
			],
		);
	}
}
