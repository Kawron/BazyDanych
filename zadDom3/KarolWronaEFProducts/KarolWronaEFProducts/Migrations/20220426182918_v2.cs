using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace KarolWronaEFProducts.Migrations
{
    public partial class v2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SuppliedBySupplierID",
                table: "Products",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Products_SuppliedBySupplierID",
                table: "Products",
                column: "SuppliedBySupplierID");

            migrationBuilder.AddForeignKey(
                name: "FK_Products_Suppliers_SuppliedBySupplierID",
                table: "Products",
                column: "SuppliedBySupplierID",
                principalTable: "Suppliers",
                principalColumn: "SupplierID",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Products_Suppliers_SuppliedBySupplierID",
                table: "Products");

            migrationBuilder.DropIndex(
                name: "IX_Products_SuppliedBySupplierID",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "SuppliedBySupplierID",
                table: "Products");
        }
    }
}
