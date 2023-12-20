#!/bin/bash

cd `dirname $0`
if [ ! -e ".env" ]; then
    echo ".env ファイルが存在しません"
    exit
fi
source ./.env

# レジストリ名
registries=(all)
IFS=',' read -ra values <<< "${REGISTRIES}"
registries+=(${values[@]})

# イメージ名
images=(all)
IFS=',' read -ra values <<< "${IMAGES}"
images+=(${values[@]})


# 処理種別の入力
echo "[r] rm | [t] tag | [pl] pull | [ps] push ?"
read proc
if [[ -z ${proc} ]]; then
	echo "nothing done..."
	exit
elif [[ ${proc} =~ [rt] || ${proc} == "pl" || ${proc} == "ps" ]]; then
    echo "select is [${proc}]" 
    echo ""
else
    echo "proc input miss done..."
    exit
fi


# レジストリ名とNoを表示
i=0
for val in ${registries[@]}
do
    echo "$i :  $val"
    ((i = i + 1))
done

# No の入力
echo "[No ?]"
read regno
if [[ -z ${regno}  || ((regno -ge i)) ]]; then
    echo "input miss done..."
    exit
fi
if [[ ${regno} =~ ^[0-9]+$ ]]; then
    :
else
    echo "registry number input miss done..."
    exit
fi

echo "select is [${registries[regno]}]"
echo ""


# イメージ名とNoを表示
i=0
for val in ${images[@]}
do
    echo "$i :  $val"
    ((i = i + 1))
done

# No の入力
echo "[No ?]"
read imgno
if [[ -z ${imgno}  || ((imgno -ge i)) ]]; then
    echo "input miss done..."
    exit
fi
if [[ ${imgno} =~ ^[0-9]+$ ]]; then
    :
else
    echo "image number input miss done..."
    exit
fi

echo "select is [${images[imgno]}]"
echo ""


echo "********** Start **********"

# ==========
# docker image 処理
#
# $1: イメージ処理種類： 'r' 削除 't' タグ付け 'pl' プル 'ps' プッシュ
# $2: レジストリ名
# $3: イメージ名
# ==========
docker_image() {
    if [ $2 == "local" ]; then
        registry_name=
    else
        registry_name=$2/
    fi

    origin_image_name=${PROJECT_NAME}/$3
    target_image_name=${registry_name}${PROJECT_NAME}/$3

    if [[ $1 == "r" ]]; then
        echo "remove [${target_image_name}]"
        docker image rm ${target_image_name}

    elif [[ $1 == "t" ]]; then
        if [ ${origin_image_name} != ${target_image_name} ]; then
            echo "tag [${origin_image_name}] --> [${target_image_name}]"
            docker image tag ${origin_image_name} ${target_image_name}
        fi
    
    elif [[ $1 == "pl" ]]; then
        if [[ ${registry_name} != "" ]]; then
            echo "pull [${target_image_name}]"
            docker image pull ${target_image_name}
        fi

    elif [[ $1 == "ps" ]]; then
        if [[ ${registry_name} != "" ]]; then
            echo "push [${target_image_name}]"
            docker image push ${target_image_name}
        fi
    fi
}

# ==========
# イメージでループ
#
# $1: イメージ処理種類： 'r' 削除 't' タグ付け 'p' プッシュ 
# $2: レジストリ名
# ==========
image_loop() {
    if [[ ((${imgno} == 0)) ]]; then  # Image [No ?] で all を選択した場合
        for tmp in ${images[@]}
        do
            if [[ ${tmp} == "all" ]]; then
                continue
            fi
            
            docker_image $1 $2 ${!tmp}
        done
    else                       # Image [No ?] で all 以外を選択した場合
        env=${images[$imgno]}
        docker_image $1 $2 ${!env}
    fi
}


# 処理
if [[ ((${regno} == 0)) ]]; then  # Registry [No ?] で all を選択した場合
    for tmp in ${registries[@]}
    do
        if [[ ${tmp} == "all" ]]; then
            continue
        fi
        
        image_loop ${proc} ${tmp}
    done
else                       # Registry [No ?] で all 以外を選択した場合
    image_loop ${proc} ${registries[$regno]}
fi

echo "********** END **********"