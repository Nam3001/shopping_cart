<template>
  <div>
    <div class="container">
      <h1 class="heading">Create new Product</h1>
      <form @submit.prevent="handleSubmit">
        <label for="productName">Product Name:</label>
        <BaseInput v-model="productName" id="productName" required />

        <label for="price">Price:</label>
        <BaseInput type="number" v-model="price" id="price" required />

        <label for="quantity">Quantity:</label>
        <BaseInput type="number" v-model="quantity" id="quantity" required />


        <label for="thumbnailUrl">Thumbnail:</label>
        <input class="file-input" type="file" id="thumbnailUrl" accept="image/*"
          @change="handleFileUpload" required />
        <br />

        <div class="thumbnail-control" v-if="thumbnail">
          <p>Preview thumbnail:</p>
          <img :src="thumbnail_url" alt="Preview" />
        </div>

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

  </div>
</template>

<script>
import BaseInput from '@/components/BaseInput.vue';
import api from '@/services/api';
// import PATHS from '@/services/paths';
export default {
  data() {
    return {
      productName: '',
      price: 0,
      quantity: 0,
      thumbnail: '',
      thumbnail_url: '',
    }
  },
  components: {
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

      try {
        await api.post('/products', data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })


        alert('Product created successfully');
        this.$router.replace({ name: 'admin-products' });
      } catch (error) {
        alert('Error creating product:' + error);
      }
    },
    handleFileUpload(e) {
      const file = e.target.files[0]
      this.thumbnail = file

      if (file && file.type.startsWith('image/')) {
        this.thumbnail_url = URL.createObjectURL(file);
      } else {
        this.thumbnail_url = '';
      }
    }
  }
}
</script>
<style scoped>
.thumbnail-control {
  p {
    margin: 10px 0;
  }
  
  img {
    height: 100px;
    margin: 10px 0;
  }
}
.file-input {
  width: 100%;
  margin-top: 8px;
}
.heading {
  margin: 10px;
  text-align: center;
}
.container {
  padding: 10px 50px;
}
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