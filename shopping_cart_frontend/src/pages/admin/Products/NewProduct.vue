<template>
  <div>
    <ProductForm :on-submit="handleSubmit" type="new" />
  </div>
</template>

<script>
import ProductForm from '@/components/ProductForm.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
export default {
  name: 'AdminNewProductPage',
  data() {
    return {
      productName: '',
      price: 0,
      quantity: 0,
      thumbnail: '',
      thumbnailUrl: '',
    }
  },
  components: {
    ProductForm
  },
  methods: {
    handleSubmit: async function (product) {
      const data = new FormData();
      data.append('product_name', product?.productName);
      data.append('price', product?.price);
      data.append('quantity', product?.quantity);
      data.append('thumbnail', product?.thumbnail);
      data.append('unit_id', product.unitId); // Assuming unit is a number, you can change it to the appropriate value
      data.append('category_id', product.categoryId)
      
      try {
        await api.post(PATHS.products, data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Product created successfully');
        this.$router.replace({ name: 'admin-products' });
      } catch (error) {
         const errorMessages = error.response?.data?.error || 'Unknown error';
        alert('Error creating product:' + errorMessages);
      }
    },
    handleFileUpload(e) {
      const file = e.target.files[0]
      this.thumbnail = file

      if (file && file.type.startsWith('image/')) {
        this.thumbnailUrl = URL.createObjectURL(file);
      } else {
        this.thumbnailUrl = '';
      }
    }
  }
}
</script>\