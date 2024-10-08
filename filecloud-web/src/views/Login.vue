<script setup>
import { getCurrentInstance, ref, watch, watchEffect } from 'vue';
import formRules from '@/utils/formRules';
import regularCode from "@/utils/regularCode"
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import RequestCodeButton from '@/components/common/RequestCodeButton.vue';
import { useVerifyCode } from '@/hooks/VerifyCode';

const router = useRouter()
const { proxy } = getCurrentInstance();
const api = proxy.$api;
const local = proxy.$local;

//切换卡片类型：0 登录，1 注册，2 忘记密码
let containIndex = ref(0)



//用户信息
const userInfo = ref({
  userName: '',
  password: '',
  verifyPassword: '',
  email: '',
  verifyCode: ''
})


//登录表单 ref
const loginFormRef = ref(null);
//登录点击事件
const loginClick = () => {
  const userData = userInfo.value;
  loginFormRef.value.validate(async (valid) => {
    if (valid) {
      //请求登录接口
      let result = await api.login(userData);
      if (result.success) {
        const user = result.data;
        ElMessage.success(`你好${user.userName}，欢迎登录(*^_^*)`)
        //用户数据存入本地存储
        local.saveToLocal(local.getLoginKey(), user);
        router.push('/home');
      } else {
        ElMessage.error(result.Message != '' && result.Message != null ? result.Message : '用户名或密码错误，请重试')
      }
    }
  })
}


//注册表单 ref
const registryFormRef = ref(null);
//注册点击事件
const registerClick = () => {
  const user = userInfo.value;

  //启用表单校验
  registryFormRef.value.validate(async (valid) => {
    if (valid) {
      //对邮箱验证码进行校验
      let result = await api.checkCode(user);
      if (!result.success) {
        ElMessage.error('邮箱验证码校验错误，请重新输入');
        return;
      }

      //用户注册
      result = await api.register(user);
      if (result.success) {
        ElMessage.success("注册成功，请登录");
        containIndex.value = 0;
      } else {
        ElMessage.error(result.message != '' && result.message != null ? result.message : '注册用户失败，请重试');
      }
    }
  });
}

//重置密码框 ref
const forgotFormRef = ref(null);
//重置密码点击事件
const resetPasswordClick = () => {
  const user = userInfo.value;

  //开启表单验证
  forgotFormRef.value.validate(async valid => {
    if (!valid) {
      return;
    }

    //对邮箱验证码进行校验
    let result = await api.checkCode(user);
    if (!result || !result.success) {
      ElMessage.error('邮箱验证码校验错误，请重新输入');
      return;
    }

    result = await api.resetPassword(user);
    console.log(result);
    if (result && result.success) {
      ElMessage.success('密码重置成功，请重新登录');
      containIndex.value = 0;
    } else {
      ElMessage.error('密码重置失败，请重试');
    }
  });
}



//表单验证
const passwordVerify = regularCode.passwordVerify;
const validatorVerifyPassword = (rule, value, callback) => {
  if (!passwordVerify.test(value)) {
    callback(new Error("密码 4 ~ 16 位，不包含特殊字符"))
  } else if (value != userInfo.value.password) {
    callback(new Error("密码和再次输入的密码不一致"))
  } else {
    callback()
  }
}
let registryFormRules = { ...formRules }
registryFormRules.verifyPassword = [
  { required: true, message: '密码不可以为空', trigger: 'blur' },
  { validator: validatorVerifyPassword, trigger: 'blur' }
]



//邮箱验证码发送事件
const senderVerifyCode = () => { return useVerifyCode(userInfo.value); }
//验证邮箱合法性，然后禁用或者启用发送验证码按钮
let enableSenderCodeBtn = ref(false);
watchEffect(() => {
  var regex = regularCode.emailVerify;
  var eamil = userInfo.value.email;
  if (eamil != '' && regex.test(eamil)) {
    enableSenderCodeBtn.value = true;
  } else {
    enableSenderCodeBtn.value = false;
  }
});


//containIndex发生变化，将userInfo内容重置
watch(containIndex, (newVal, oldVal) => {
  if (newVal != oldVal) {
    userInfo.value = {
      userName: '',
      password: '',
      verifyPassword: '',
      email: '',
      verifyCode: ''
    }
  }
});
</script>

<template>
  <div class="login">
    <div class="loginNest">
      <div class="title">
        <el-image src="/static/images/logo.png" class="logoImg"></el-image>
        <el-text v-if="containIndex == 0">在线网盘</el-text>
        <el-text v-if="containIndex == 1">欢迎注册</el-text>
        <el-text v-if="containIndex == 2">密码重置</el-text>
      </div>
      <div class="container">
        <!-- 登录 -->
        <div class="containerContent" v-if="containIndex == 0">
          <el-form :model="userInfo" :rules="formRules" ref="loginFormRef">
            <el-form-item prop="email">
              <el-input size="large" v-model="userInfo.email" placeholder="请输入邮箱" clearable></el-input>
            </el-form-item>
            <el-form-item prop="password">
              <el-input type="password" size="large" v-model="userInfo.password" placeholder="请输入登录密码" clearable
                show-password></el-input>
            </el-form-item>
            <el-form-item class="loginOrRegisterItem">
              <el-button type="primary" size="large" @click="loginClick">登录</el-button>
            </el-form-item>
          </el-form>
          <div class="buttomButton">
            <el-button link size="small" @click="containIndex = 2">忘记密码</el-button>
            <el-button link size="small" @click="containIndex = 1">免费注册</el-button>
          </div>
        </div>


        <!-- 注册 -->
        <div class="containerContent" v-if="containIndex == 1">
          <el-form :model="userInfo" :rules="registryFormRules" ref="registryFormRef">
            <el-form-item prop="userName">
              <el-input size="large" v-model="userInfo.userName" placeholder="用户名" clearable></el-input>
            </el-form-item>
            <el-form-item prop="password">
              <el-input type="password" size="large" v-model="userInfo.password" placeholder="请设置你的登录密码" clearable
                show-password></el-input>
            </el-form-item>
            <el-form-item prop="verifyPassword">
              <el-input type="password" size="large" v-model="userInfo.verifyPassword" placeholder="请再次输入你的登录密码"
                clearable show-password></el-input>
            </el-form-item>
            <el-form-item prop="email">
              <el-input size="large" v-model="userInfo.email" placeholder="请输入邮箱地址" clearable>
                <template #append>
                  <RequestCodeButton :text="'获取验证码'" v-model:enable="enableSenderCodeBtn" :number="120"
                    :on-sender="senderVerifyCode" />
                </template>
              </el-input>
            </el-form-item>
            <el-form-item prop="verifyCode">
              <el-input size="large" v-model="userInfo.verifyCode" placeholder="请输入邮箱验证码" clearable></el-input>
            </el-form-item>
            <el-form-item class="loginOrRegisterItem">
              <el-button type="primary" size="large" @click="registerClick">注册</el-button>
            </el-form-item>
          </el-form>
          <div class="buttomButton">
            <el-button link size="small"></el-button>
            <el-button link size="small" @click="containIndex = 0">>>前往登录</el-button>
          </div>
        </div>


        <!-- 忘记密码 -->
        <div class="containerContent" v-if="containIndex == 2">
          <el-form :model="userInfo" :rules="registryFormRules" ref="forgotFormRef">
            <el-form-item prop="password">
              <el-input type="password" size="large" v-model="userInfo.password" placeholder="输入你的新密码" clearable
                show-password></el-input>
            </el-form-item>
            <el-form-item prop="verifyPassword">
              <el-input type="password" size="large" v-model="userInfo.verifyPassword" placeholder="确认你的新密码" clearable
                show-password></el-input>
            </el-form-item>
            <el-form-item prop="email">
              <el-input size="large" v-model="userInfo.email" placeholder="请输入邮箱地址" clearable>
                <template #append>
                  <RequestCodeButton :text="'获取验证码'" v-model:enable="enableSenderCodeBtn" :number="120"
                    :on-sender="senderVerifyCode" />
                </template>
              </el-input>
            </el-form-item>
            <el-form-item prop="verifyCode">
              <el-input size="large" v-model="userInfo.verifyCode" placeholder="请输入邮箱验证码" clearable></el-input>
            </el-form-item>
            <el-form-item class="loginOrRegisterItem">
              <el-button type="primary" size="large" @click="resetPasswordClick">重置密码</el-button>
            </el-form-item>
          </el-form>
          <div class="buttomButton">
            <el-button link size="small" @click="containIndex = 0">>>前往登录</el-button>
            <el-button link size="small" @click="containIndex = 1">前往注册</el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login {
  height: calc(100vh);
  width: calc(100vw);
  background-color: #fafafa;
}

.loginNest {
  height: auto;
  width: auto;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-top: 60px;
}

.title {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.logoImg {
  width: 64px;
  height: 64px;
}

.title .el-text {
  color: #2c3e50;
  font-weight: bold;
  font-size: 2.5em;
}

.containerContent {
  width: 420px;
  height: auto;
  margin: 45px;
  padding: 35px 35px 15px 35px;
  box-shadow: 0 0 25px #909399;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: transparent;
}

.el-form {
  width: 100%;
  height: 100%;
}

.el-form .el-form-item {
  margin-bottom: 20px;
}

.el-form .el-input {
  background-color: #ffffff;
}

.loginOrRegisterItem .el-button {
  width: 100%;
}

.buttomButton {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin: 8px 0;
}

.buttomButton .el-button {
  color: #9b9ea0;
}

:deep(.el-input-group__append) {
  background-color: #ffffff;
  color: gray;
}

:deep(.el-input-group__append:hover) {
  background-color: rgba(72, 143, 249, 0.1);
  color: #488ff9;
}
</style>