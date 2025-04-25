<template>
  <div>
    <div class="form-container">
      <h1 class="heading">Update Product</h1>
      <form @submit.prevent="handleSubmit">
        <label for="productName">Product Name:</label>
        <BaseInput v-model="product.product_name" id="productName" required />

        <label for="price">Price:</label>
        <BaseInput type="number" v-model="product.price" id="price" required />

        <label for="quantity">Quantity:</label>
        <BaseInput type="number" v-model="product.quantity" id="quantity" required />

        <label for="thumbnail">New thumbnail:</label>
        <input class="new-thumbnail" type="file" id="thumbnail" accept="image/*" @change="handleFileUpload"
          :required="!product?.thumbnail_url || product?.thumbnail_url?.length === 0" />
        <br />

        <div class="thumbnail-container">
          <div class="preview-thumbnail" v-if="newThumbnail">
            <p>Preview new thumbnail:</p>
            <img :src="newThumbnail" alt="preview new thumbnail" />
          </div>

          <div class="current-thumbnail" v-if="currentThumbnail">
            <p>Current thumbnail:</p>
            <img :src="currentThumbnail" alt="current thumbnail" />
          </div>
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
      currentThumbnail: null, // new chosen thumbnail
      product: {},
      newThumbnail: null
    }
  },
  components: {
    BaseInput
  },
  mounted() {
    this.getProductInfo();
  },
  methods: {
    handleSubmit: async function () {
      const data = new FormData();
      data.append('product_name', this.product.product_name);
      data.append('price', this.product.price);
      data.append('quantity', this.product.quantity);
      if (this.newThumbnail) {
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
        this.newThumbnail = URL.createObjectURL(file);
      } else {
        this.newThumbnail = null;
      }
    },
    getProductInfo() {
      let productId = this.$route.params.id;
      api.get(PATHS.productInfo(productId))
        .then(response => {
          this.product = response.data;

          this.currentThumbnail = this.product.thumbnail_url;

        })
        .catch(error => {
          console.error('Error fetching products:', error);
          this.$router.replace({ name: 'not-found' })
        });
    }
  }
}
</script>
<style scoped>
.thumbnail-container {
  display: flex;
}
.current-thumbnail,
.preview-thumbnail {
  width: 300px;

  p {
    margin-top: 10px;
  }

  img {
    height: 100px;
    margin: 10px 0;
  }
}

.new-thumbnail {
  width: 100%;
  margin-top: 8px;
}

.form-container {
  padding: 10px 50px;
}

.heading {
  margin: 10px;
  text-align: center;
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