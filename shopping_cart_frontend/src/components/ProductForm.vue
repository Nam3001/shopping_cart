<template>
  <div>
    <div class="form-container">
      <h1 class="heading">{{this.type === 'new' ? 'Create new Product' : 'Update product'}}</h1>
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

        <label for="thumbnail">New thumbnail:</label>
        <input class="new-thumbnail" type="file" id="thumbnail" accept="image/*" @change="handleFileUpload"
          :required="this.type === 'new' ? true : !thumbnailUrl || thumbnailUrl?.length === 0" />
        <br />

        <div class="thumbnail-container">
          <div class="preview-thumbnail" v-if="thumbnailUrl">
            <p>Thumbnail:</p>
            <img :src="thumbnailUrl" alt="thumbnail" />
          </div>

          <div class="new-thumbnail" v-if="newThumbnailUrl">
            <p>New thumbnail:</p>
            <img :src="newThumbnailUrl" alt="new thumbnail" />
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
      newThumbnailUrl: null,
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
    BaseInput
  },
  mounted() {
    if(this.type === 'edit')
      this.getProductInfo()

    this.getCategories()
    this.getUnits()
  },
  methods: {
    handleFileUpload(e) {
      const file = e.target.files[0]
      this.thumbnail = file

      if(this.type === 'new') {
        if (file && file.type.startsWith('image/')) {
        this.thumbnailUrl = URL.createObjectURL(file)
        } else {
          this.thumbnailUrl = ''
        }
      } else if (this.type === 'edit') {
        if (file && file.type.startsWith('image/')) {
          this.newThumbnailUrl = URL.createObjectURL(file)
        } else {
          this.newThumbnailUrl = null
        }
      }
    },
    handleSubmit() {
       const cleanDescription = DOMPurify.sanitize(this.editorDescriptionContent)

      let data = {
        productName: this.productName,
        price: this.price,
        quantity: this.quantity,
        thumbnail: this.thumbnail,
        unitId: this.selectedUnit,
        categoryId: this.selectedCategory,
        description: cleanDescription
      }

      if(this.type === 'edit') 
        data.newThumbnail = this.thumbnail
      
      this.onSubmit(data)
    },
    getProductInfo() {
      let productId = this.$route.params.id
      api.get(PATHS.productInfo(productId))
        .then(response => {
          this.productName = response.data.product_name
          this.price = response.data.price
          this.quantity = response.data.quantity
          this.thumbnailUrl = response.data.thumbnail_url
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
    }
  }
}
</script>
<style scoped>
.thumbnail-container {
  display: flex;
}
.new-thumbnail,
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
  margin-bottom: 10px;
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