<template>
  <ProductForm :on-submit="handleSubmit" type="edit" />
</template>

<script>
import ProductForm from '@/components/ProductForm.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';

export default {
  name: 'AdminEditProductPage',
  data() {
    return {
      currentThumbnail: null, // new chosen thumbnail
      product: {},
      newThumbnail: null
    }
  },
  components: {
    ProductForm
  },
  methods: {
    handleSubmit: async function (product) {
      const data = new FormData();
      data.append('product_name', product.productName)
      data.append('price', product.price);
      data.append('quantity', product.quantity);
      data.append('unit_id', product.unitId),
      data.append('category_id', product.categoryId)
      data.append('description', product.description)

      if(product?.thumbnailsToDelete) {
        product?.thumbnailsToDelete.forEach(toDelete => {
          data.append('thumbnails_id_to_delete[]', toDelete)
        })
      }

      if(product?.thumbnails) {
        product.thumbnails.forEach(thumbnail => {
          data.append('thumbnails[]', thumbnail)
        });
      }

      try {
        let productId = this.$route.params.id;
        await api.patch(PATHS.updateProduct(productId), data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Product updated successfully');
        this.$router.replace({ name: 'admin-products' })
      } catch (error) {
        let errorMessage = error.response?.data?.error
        alert('Error updating product: ' + errorMessage)
      }
    }
  }
}
</script>
