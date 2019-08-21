package com.nostyling.create.util.jsoup;

import cn.hutool.core.io.file.FileWriter;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import lombok.Data;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-08-20 18:43
 * @description: 利用 jsoup 从国家统计局获得 区划代码和城乡划分代码
 **/
public class tjyqhdmhcxhfdm {
    public static void main(String[] args) throws IOException {

        ArrayList <Province> provinces = new ArrayList <>();

        ArrayList <City> cities = new ArrayList <>();
        ArrayList <City> countys = new ArrayList <>();
        ArrayList <City> towns = new ArrayList <>();

        ArrayList <Village> villages = new ArrayList <>();

        String url = "http://www.stats.gov.cn/tjsj/tjbz/tjyqhdmhcxhfdm/2018/";
        String index = "index.html";


        // 省 直辖市
        String provincetr = "provincetr";

        // 市
        String citytr = "citytr";
        // 区县
        String countytr = "countytr";
        // 镇/办事处/乡
        String towntr = "towntr";

        // 社区/村委会
        String villagetr = "villagetr";

        // 省/直辖市
        Document documentProvince = getDocument(url + index);
        getProvince(documentProvince, provinces);
        System.out.println("全国" + "共计：" + provinces.size() + "个省。");
        new FileWriter("C:\\Users\\shiliang\\Desktop\\新建文件夹\\" + "documentProvince" +
                System.currentTimeMillis()+".json").append(JSON.toJSONString(provinces, SerializerFeature.WriteMapNullValue));

        // 市
        for (Province province : provinces) {
            int size = cities.size();
            Document documentCity = getDocument(url + province.href);
            getCity(documentCity, province.name, cities, citytr);
            System.out.println(province.name + "省共计：" + (cities.size() - size) + "个市。");
        }
        new FileWriter("C:\\Users\\shiliang\\Desktop\\新建文件夹\\" + "cities" +
                System.currentTimeMillis()+".json").append(JSON.toJSONString(cities, SerializerFeature.WriteMapNullValue));
        // 区县
        for (City city : cities) {
            int size = countys.size();
            Document documentCity = getDocument(url + city.href);
            getCity(documentCity, city.name, countys, countytr);
            System.out.println(city.name + "市共计：" + (countys.size() - size) + "个区/县。");

        }
        new FileWriter("C:\\Users\\shiliang\\Desktop\\新建文件夹\\" + "countys" +
                System.currentTimeMillis()+".json").append(JSON.toJSONString(countys, SerializerFeature.WriteMapNullValue));
        // 镇/办事处/乡
        for (City count : countys) {
            int size = towns.size();
            Document documentCity = getDocument(url + count.code.substring(0, 2) + "/" + count.href);
            getCity(documentCity, count.name, towns, towntr);
            System.out.println(count.name + " 区/县共计：" + (towns.size() - size) + "个镇/办事处/乡。");

        }
        new FileWriter("C:\\Users\\shiliang\\Desktop\\新建文件夹\\" + "towns" +
                System.currentTimeMillis()+".json").append(JSON.toJSONString(towns, SerializerFeature.WriteMapNullValue));


        // 社区/村委会
        for (City count : towns) {
            int size = villages.size();
            Document documentCity = getDocument(url + count.code.substring(0, 2) + "/" + count.code.substring(2, 4) + "/" + count.href);
            getVillage(documentCity, count.name, villages, villagetr);
            System.out.println(count.name + " 镇/办事处/乡共计：" + (villages.size() - size) + "个社区/村委会。");

        }
        new FileWriter("C:\\Users\\shiliang\\Desktop\\新建文件夹\\" + "villages" +
                System.currentTimeMillis()+".json").append(JSON.toJSONString(villages, SerializerFeature.WriteMapNullValue));
        System.out.println("抓取结束");
    }

    static Document getDocument(String url) {
        return getDocument(url, 1);
    }

    static Document getDocument(String url, int time) {
        Document document = null;
        try {
            document = Jsoup.connect(url)
                    .timeout(5000)
                    .get();
            String title = document.title();
            if ("访问验证".equals(title)) {
                System.out.println("触发访问验证！");
                System.out.println("触发访问验证！");
                System.out.println("触发访问验证！");
                int i = 3 / 0;
            }
            Thread.sleep(100 * time);
        } catch (IOException e) {
            e.printStackTrace();
            try {
                Thread.sleep(500 * time * time);//java.net.SocketTimeoutException: Read timed out
                time++;
                document = getDocument(url, time);
                if (10 == time) {
                    throw new RuntimeException(e);
                }
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return document;
    }

    static void printTitle(Document document) {
        System.out.println(document.title());
    }

    static ArrayList <Province> getProvince(Document document, ArrayList <Province> provinces) {

        //获取HTML页面中的所有链接
        Elements links = document.select("a[href]");
        for (Element link : links) {
            String href = link.attr("href");
            String text = link.text();
            if (href.endsWith("html")) {
                provinces.add(new Province(href, text));
            }

        }
        return provinces;
    }

    static ArrayList <City> getCity(Document document, String parentName, ArrayList <City> cities, String className) {

        //获取HTML页面中的所有链接
        Elements links = document.getElementsByClass(className);
        for (Element link : links) {

            if (link.childNodeSize() > 0) {
                try {
                    //Element child = link.child(0).child(0);
                    //Element child2 = link.child(1).child(0);
                    Elements selects = link.select("a[href]");
                    if (2 == selects.size()) {
                        selects.get(0);
                        String href = selects.get(0).attr("href");
                        String code = selects.get(0).text();
                        String text = selects.get(1).text();
                        if (href.endsWith("html")) {
                            cities.add(new City(parentName, href, text, code));
                        }
                    } else {
                        System.out.println("link.childNodeSize() <= 0");
                    }

                } catch (IndexOutOfBoundsException e) {
                    e.printStackTrace();
                }
            } else {
                System.out.println("link.childNodeSize() <= 0");
            }


        }
        return cities;
    }

    static ArrayList <Village> getVillage(Document document, String parentName, ArrayList <Village> cities, String className) {

        //获取HTML页面中的所有链接
        Elements links = document.getElementsByClass(className);
        for (Element link : links) {
            if (link.childNodeSize() > 0) {
                try {
                    Element child = link.child(0);
                    Element child2 = link.child(1);
                    Element child3 = link.child(2);
                    String code = child.text();
                    String typeCode = child2.text();
                    String text = child3.text();

                    cities.add(new Village(parentName, typeCode, text, code));
                } catch (IndexOutOfBoundsException e) {
                    e.printStackTrace();
                }
            } else {
                System.out.println("link.childNodeSize() <= 0");

            }

        }
        return cities;
    }

}

/**
 * /省/自治区/直辖市;
 */
@Data
class Province {
    String href;
    String name;

    public Province(String href, String name) {
        this.href = href;
        this.name = name;
    }
}

/**
 * 地区(省下面的地级市);
 */
@Data
class City {
    String parentName;
    String href;
    String name;
    /**
     * 统计用区划代码
     */
    String code;

    public City(String parentName, String href, String name, String code) {
        this.parentName = parentName;
        this.href = href;
        this.name = name;
        this.code = code;
    }

}


/**
 * 社区/村委会
 */
@Data
class Village {
    String parentName;
    String text;
    /**
     * 城乡分类代码
     */
    String typeCode;
    /**
     * 统计用区划代码
     */
    String code;

    public Village(String parentName, String typeCode, String text, String code) {
        this.parentName = parentName;
        this.typeCode = typeCode;
        this.text = text;
        this.code = code;
    }

}