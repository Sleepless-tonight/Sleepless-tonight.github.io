package com.nostyling.create.util.test;

import org.apache.commons.beanutils.ConvertUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-03-13 14:55
 * @description:
 **/
public class TestCopyOfRange {


    public static void main(String[] args) {
        List <String> wareIdList = Arrays.asList("1","2","3","4","5","6");
        List <Long> wareid = new ArrayList <>(wareIdList.size());
        List <String> wareid2 = new ArrayList <>(wareIdList.size());
        long[] strArrNum = (long[]) ConvertUtils.convert(wareIdList.toArray(new String[]{}),long.class);

        long[] longs = Arrays.stream(wareIdList.toArray(new String[]{})).mapToLong(Long::valueOf).toArray();

        List<Long> result = wareIdList.stream().map(id -> Long.valueOf(id)).collect(Collectors.toList());

        Long[] longs1 = Arrays.copyOfRange(wareIdList.toArray(),0,longs.length+1,Long[].class );

        System.out.println(result.toString());
    }
}
