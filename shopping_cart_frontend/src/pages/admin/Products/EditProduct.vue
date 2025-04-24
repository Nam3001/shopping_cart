<template>
  <div>
    <div style="padding: 10px 50px;">
      <h1 style="margin: 10px; text-align: center;">Update Product</h1>
      <form @submit.prevent="handleSubmit">
        <label for="productName">Product Name:</label>
        <BaseInput v-model="product.product_name" id="productName" required />

        <label for="price">Price:</label>
        <BaseInput type="number" v-model="product.price" id="price" required />

        <label for="quantity">Quantity:</label>
        <BaseInput type="number" v-model="product.quantity" id="quantity" required />

        <label for="thumbnail">Preview thumbnail:</label>
        <input style="width: 100%; margin-top: 8px;" type="file" id="thumbnail" accept="image/*"
          @change="handleFileUpload" :required="!product?.thumbnail_url || product?.thumbnail_url?.length === 0" />
        <br />

        <!-- <label for="unit">Unit:</label> -->
        <!-- <BaseInput v-model="productName" id="unit" /> -->
        <!-- <select id="unit">
        <option disabled value="">-- Choose unit --</option>
        <option value="kg" >KG</option>
        <option value="g">G</option>
       </select> -->
        <div v-if="thumbnail">
          <p style="margin-top: 10px;">Current thumbnail:</p>
          <img :src="thumbnail" alt="Preview" style="height: 100px; margin: 10px 0;" />
        </div>

        <input id="submit" type="submit" value="Update" />
      </form>
    </div>

  </div>
</template>

<script>
import BaseInput from '@/components/BaseInput.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';

export default {
  data() {
    return {
      thumbnail: null,
      product: {}
    }
  },
  components: {
    BaseInput
  },
  mounted() {
    this.getProducts();
  },
  methods: {
    handleSubmit: async function () {
      const data = new FormData();
      data.append('product_name', this.product.product_name);
      data.append('price', this.product.price);
      data.append('quantity', this.product.quantity);
      if (this?.product?.thumbnail) {
        data.append('thumbnail', this.product.thumbnail);
      }
      data.append('unit_id', this.product.unit_id); // Assuming unit is a number, you can change it to the appropriate value

      try {
        let productId = this.$route.params.id;
        await api.patch(PATHS.updateProduct(productId), data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Product created successfully');
        this.$router.replace({ name: 'admin-products' });
      } catch (error) {
        alert('Error updating product: ' + error);
      }
    },
    handleFileUpload(e) {
      const file = e.target.files[0]
      this.product.thumbnail = file

      if (file && file.type.startsWith('image/')) {
        this.thumbnail = URL.createObjectURL(file);
      } else {
        this.thumbnail = null;
      }
    },
    getProducts() {
      let productId = this.$route.params.id;
      api.get(PATHS.productInfo(productId))
        .then(response => {
          this.product = response.data;

          this.thumbnail = this.product.thumbnail_url;

        })
        .catch(error => {
          console.error('Error fetching products:', error);
        });
    }
  }
}
</script>
<style scoped>
#submit {
  background-color: #007204;
  /* Green */
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
  background-color: #005f03;
  /* Darker green */
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