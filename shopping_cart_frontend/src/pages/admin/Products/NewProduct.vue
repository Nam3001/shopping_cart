<template>
  <AdminLayout>
    <div style="padding: 10px 50px;">
      <h1 style="margin: 10px; text-align: center;">Create new Product</h1>
    <form @submit.prevent="handleSubmit">
      <label for="productName">Product Name:</label>
      <BaseInput v-model="productName" id="productName" required />

      <label for="price">Price:</label>
      <BaseInput type="number" v-model="price" id="price" required />

      <label for="quantity">Quantity:</label>
      <BaseInput type="number" v-model="quantity" id="quantity" required />


      <label for="thumbnailUrl">Thumbnail:</label>
       <input  style="width: 100%; margin-top: 8px;" type="file" id="thumbnailUrl" accept="image/*" @change="handleFileUpload" required />
       <br />

      <!-- <label for="unit">Unit:</label> -->
      <!-- <BaseInput v-model="productName" id="unit" /> -->
       <!-- <select id="unit">
        <option disabled value="">-- Choose unit --</option>
        <option value="kg" >KG</option>
        <option value="g">G</option>
       </select> -->
      
      <input id="submit" type="submit" value="Create new" />
    </form>
    </div>

  </AdminLayout>
</template>

<script>
  import BaseInput from '@/components/BaseInput.vue';
  import AdminLayout from '@/layouts/AdminLayout.vue';
import api from '@/services/api';
  export default {
    data() {
      return {
        productName: '',
        price: '0',
        quantity: '0',
        thumbnail: '',
        unit: '',
      }
    },
    components: {
      AdminLayout,
      BaseInput
    },
    methods: {
      handleSubmit: async function () {
        const data = new FormData();
        data.append('product_name', this.productName);
        data.append('price', this.price);
        data.append('quantity', this.quantity);
        data.append('thumbnail', this.thumbnail);
        data.append('unit_id', 1); // Assuming unit is a number, you can change it to the appropriate value

        console.log(data.get('product_name'), data.get('price'), data.get('quantity'), data.get('thumbnail'), data.get('unit_id'));
        try {
          await api.post('/products', data, {
            headers: {
              'Content-Type': 'multipart/form-data',
              Authorization: `Bearer ${localStorage.getItem('access_token')}`
            }
          })

          alert('Product created successfully');
          this.$router.replace({ name: 'admin-products' });
        } catch (error) {
          console.error('Error creating product:', error);
        }
      },
      handleFileUpload(e) {
        this.thumbnail = e.target.files[0]
        console.log(this.thumbnail);
      }
    }
  }
</script>
<style scoped>
#submit {
  background-color: #007204; /* Green */
  border: none;
  color: white;
  padding: 10px 10px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
  border-radius: 5px;
  margin-top: 20px;
}

#submit:hover {
  background-color: #005f03; /* Darker green */
}

/* Style cho thẻ select */
select {
  width: 100%;
  padding: 0 10px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 3px;
  height: 40px;
}

/* Style cho option (lưu ý: hỗ trợ tùy trình duyệt) */
option {
  padding: 10px;
  color: #333;
  background-color: #fff;
}

</style>