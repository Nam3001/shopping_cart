<template>
  <div>
    <div class="form-container">
      <h1 class="heading">{{this.type === 'new' ? 'Create new unit' : 'Update unit'}}</h1>
      <form @submit.prevent="handleSubmit">
        <label for="name-input">Unit Name:</label>
        <BaseInput v-model="unitName" id="name-input" required />

        <input id="submit" type="submit" :value="this.type === 'new' ? 'Create' : 'Update'" />
      </form>
    </div>

  </div>
</template>

<script>
import BaseInput from '@/components/BaseInput.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';

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
      unitName: '',
    }
  },
  components: {
    BaseInput
  },
  mounted() {
    if(this.type === 'edit')
      this.getUnitInfo();
  },
  methods: {
    handleSubmit() {
      this.onSubmit(this.unitName)
    },
    getUnitInfo() {
      let unitId = this.$route.params.id;
      api.get(PATHS.unitInfo(unitId))
        .then(response => {
          this.unitName = response.data.unit_name;
        })
        .catch(() => {
          this.$router.replace({ name: 'not-found' })
        });
    }
  }
}
</script>
<style scoped>
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