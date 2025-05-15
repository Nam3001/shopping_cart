<template>
  <div>
    <div class="form-container">
      <h1 class="heading">{{ this.type === 'new' ? 'Create new Product' : 'Update product' }}</h1>
      <form @submit.prevent="handleSubmit">
        <label for="productName">Product Name:</label>
        <BaseInput v-model="productName" id="productName" required />

        <label for="price">Price:</label>
        <BaseInput type="number" v-model="price" id="price" required />

        <label for="quantity">Quantity:</label>
        <BaseInput type="number" v-model="quantity" id="quantity" required />

        <label for="unit">Unit:</label>
        <select name="unit" id="unit" v-model="selectedUnit" required>
          <option v-for="unit in unitList" :value="unit.id" :key="unit.id">{{ unit.unit_name }}</option>
        </select>

        <label for="category">Category:</label>
        <select name="category" id="category" v-model="selectedCategory" required>
          <option v-for="category in categoryList" :value="category.id" :key="category.id">{{ category.name }}</option>
        </select>

        <label for="thumbnail">Choose thumbnail:</label>
        <input class="new-thumbnail" type="file" id="thumbnail" accept="image/*" @change="handleFileUpload"
          :required="this.type === 'new' || this.thumbnails.length === 0" multiple />
        <br />

        <div class="thumbnail-container">
          <div v-if="thumbnails.length > 0 || newThumbnails.length > 0">
            <p>Thumbnail:</p>
            <div class="preview-list-thumbnail">
              <!-- current thumbnails of product -->
              <div class="preview-thumbnail-item" v-for="thumbnail in thumbnails" :key="thumbnail.thumbnail_id">
                <img :src="thumbnail.thumbnail_url" alt="thumbnail" />
                <Button type="button" @click="handleDeleteCurrentThumbnail" :data-thumbnail-id="thumbnail.thumbnail_id">Xóa</Button>
              </div>

              <!-- new thumbnails to add when creating or updating product -->
              <div class="preview-thumbnail-item" v-for="(newThumbnail, idx) in newThumbnails" :key="newThumbnail.file.name">
                  <img :src="newThumbnail.url" alt="new thumbnails" />
                <Button type="button" @click="handleDeleteChoosenThumbnail" :data-thumbnail-index="idx">Xóa</Button>
              </div>
            </div>
          </div>
        </div>

        <label>Description:</label>
        <quill-editor v-model="editorDescriptionContent" :options="editorOptions" />

        <input id="submit" type="submit" :value="this.type === 'new' ? 'Create' : 'Update'" />
      </form>
    </div>

  </div>
</template>

<script>
import BaseInput from '@/components/BaseInput.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
import DOMPurify from 'dompurify'
import Button from './Button.vue';

export default {
  props: {
    type: {
      type: String,
      default: 'new'  // new or edit
    },
    onSubmit: {
      type: Function,
      required: true
    }
  },
  data() {
    return {
      newThumbnails: [],
      thumbnails: [],
      thumbnailsToDelete: [],
      productName: '',
      price: 0,
      quantity: 0,
      thumbnail: null,
      thumbnailUrl: '',
      unitList: [],
      categoryList: [],
      selectedCategory: null,
      selectedUnit: null,
      editorDescriptionContent: '',
      editorOptions: {
        theme: 'snow',
        modules: {
          toolbar: [
            ['bold', 'italic', 'underline', 'strike'],
            ['blockquote', 'code-block'],
            [{ header: 1 }, { header: 2 }],
            [{ list: 'ordered' }, { list: 'bullet' }],
            [{ script: 'sub' }, { script: 'super' }],
            [{ indent: '-1' }, { indent: '+1' }],
            [{ direction: 'rtl' }],
            [{ size: ['small', false, 'large', 'huge'] }],
            [{ header: [1, 2, 3, 4, 5, 6, false] }],
            [{ color: [] }, { background: [] }],
            [{ font: [] }],
            [{ align: [] }],
            ['link'],
            ['clean']
          ]
        }
      }
    }
  },
  components: {
    BaseInput, Button
  },
  mounted() {
    console.log(this.newThumbnails)
    if (this.type === 'edit')
      this.getProductInfo()

    this.getCategories()
    this.getUnits()
  },
  methods: {
    handleFileUpload(e) {
      const file = e.target.files[0]
      if (!file.type.startsWith('image/')) {
        alert('You can only choose image!')
        return
      }

      if (file) {
        this.newThumbnails.push({
          url: URL.createObjectURL(file),
          file: file
        })
      }

    },
    handleSubmit() {
      if(!this.editorDescriptionContent) {
        alert('Product description cannot be blank!')
        return
      }

      const cleanDescription = DOMPurify.sanitize(this.editorDescriptionContent)

      let data = {
        productName: this.productName,
        price: this.price,
        quantity: this.quantity,
        thumbnails: this.newThumbnails.map(thumbnail => thumbnail.file),
        unitId: this.selectedUnit,
        categoryId: this.selectedCategory,
        description: cleanDescription,
      }

      if(this.thumbnailsToDelete.length > 0) {
        data.thumbnailsToDelete = this.thumbnailsToDelete
      }

      this.onSubmit(data)
    },
    getProductInfo() {
      let productId = this.$route.params.id
      api.get(PATHS.productInfo(productId))
        .then(response => {
          this.productName = response.data.product_name
          this.price = response.data.price
          this.quantity = response.data.quantity
          this.thumbnails = response.data.thumbnails
          this.selectedCategory = response.data.category.id
          this.selectedUnit = response.data.unit.id
          this.editorDescriptionContent = response.data.description
        })
        .catch(() => {
          this.$router.replace({ name: 'not-found' })
        })
    },
    getCategories() {
      api.get(PATHS.categories).then(res => {
        this.categoryList = res.data?.categories
      })
    },
    getUnits() {
      api.get(PATHS.units).then(res => {
        this.unitList = res.data?.units
      })
    },
    handleDeleteCurrentThumbnail(e) {

      let thumbnailId = Number.parseInt(e.target.dataset.thumbnailId)
      this.thumbnailsToDelete.push(thumbnailId)
      this.thumbnails = this.thumbnails.filter(thumbnail => thumbnail.thumbnail_id !== thumbnailId)
    },
    handleDeleteChoosenThumbnail(e) {
      this.newThumbnails.splice(e.target.dataset.thumbnailIndex, 1)
      console.log(this.newThumbnails)
    }
  }
}
</script>
<style scoped>
.thumbnail-container {
  /* display: flex; */
}

.new-thumbnail,
.preview-list-thumbnail {
  width: 100%;
  display: flex;
  flex-wrap: wrap;
}

.preview-list-thumbnail p {
  margin-top: 10px;
}

.preview-list-thumbnail img {
  height: 100px;
  margin: 10px 0;
}

.new-thumbnail {
  width: 100%;
  margin-top: 8px;
  margin-bottom: 10px;
}

.preview-thumbnail-item img {
  display: block;
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

select {
  width: 100%;
  padding: 0 10px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 3px;
  height: 40px;
}

option {
  padding: 10px;
  color: #333;
  background-color: #fff;
}
</style>

<style lang="css">
.ql-editor {
  min-height: 300px;
}
</style>