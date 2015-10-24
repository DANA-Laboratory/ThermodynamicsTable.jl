module ICapeThermoCompounds
    export getconstproplist,gettdependentproplist,getpdependentproplist,getnumcompounds,getcompoundlist
    export getcompoundconstant,getpdependentproperty,gettdependentproperty
    using  PhysicalPropertyCalculator
    import CapeOpen.PropertyPackage
    """
      Returns the list of supported constant Physical Properties.
      #= [retval][out] =# props::Vector{ASCIIString}
    """
    function getconstproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        props = [keys(proppackage.constantstrings)...; keys(proppackage.constantfloats)...]
        return props
    end

    """
      Returns the list of supported temperature-dependent Physical Properties.
      #= [retval][out] =# props::Vector{ASCIIString})
    """
    function gettdependentproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        props = [keys(proppackage.tempreturedependents)...]
        return props
    end

    """
      Returns the list of supported pressure-dependent properties.
      #= [retval][out] =# props::Vector{ASCIIString})
    """
    function getpdependentproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        props = [keys(proppackage.pressuredependents)...]
        return props
    end

    """
      Returns the number of Compounds supported.
      #= [retval][out] =# num::Int32
    """
    function getnumcompounds(
        proppackage::PropertyPackage)
        num::Int32
        num = size(proppackage.propertytable["Compounds"])[1]
        return  num
    end

    """
      Returns the list of all Compounds. This includes the Compound identifiers recognised and extra
      information that can be used to further identify the Compounds.
        #= [retval][out] =# compIds::Vector{ASCIIString} List of Compound identifiers.
        #= [retval][out] =# formulae::Vector{ASCIIString} List of Compound formulae.
        #= [retval][out] =# names::Vector{ASCIIString} List of Compound names.
        #= [retval][out] =# boilTemps::Vector{Float64} List of boiling point temperatures.
        #= [retval][out] =# molwts::Vector{Float64} List of molecular weights.
        #= [retval][out] =# casnos::Vector{ASCIIString}) List of Chemical Abstract Service (CAS) Registry numbers.
    """
    function getcompoundlist(
        proppackage::PropertyPackage)

        compIds::Vector{Int}
        formulae::Vector{ASCIIString}
        names::Vector{ASCIIString}
        boilTemps::Vector{Float64}
        molwts::Vector{Float64}
        casnos::Vector{ASCIIString}

        compondlist=proppackage.propertytable["Compounds"]
        compIds=compondlist[:,1]
        a=compondlist[:,3]
        formulae=compondlist[:,3]
        names=compondlist[:,2]
        casnos=compondlist[:,4]
        molwts=compondlist[:,5]
        boilTemps=compondlist[:,6]

        return compIds,formulae,names,boilTemps,molwts,casnos
    end

    """
      Returns the values of constant Physical Properties for the specified Compounds.
      #= [retval][out] =# propvals::Vector{Any}
    """
    function getcompoundconstant(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# compIds::Vector{Int}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Union{AbstractString,Float64}}
        propvals=Vector{Union{AbstractString,Float64}}()     
        for prop in props
          for compId in compIds            
            push!(propvals, calculate(prop,getconstpropdata(proppackage,prop,compId)))
          end
        end
        return propvals
    end

    """
      Returns the values of pressure-dependent Physical Properties for the specified pure Compounds.
      #= [out][in] =# propvals::Vector{Float64}
    """
    function getpdependentproperty(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# pressure::Float64,
        #= [in] =# compIds::Vector{Float64}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Float64}
        propvals=Vector{Float64}()
        return propvals
    end

    """
      Returns the values of temperature-dependent Physical Properties for the specified pure Compounds.
      #= [out][in] =# propvals::Vector{Float64})
    """
    function gettdependentproperty(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# temperature::Float64,
        #= [in] =# compIds::Vector{Float64}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Float64}
        propvals=Vector{Float64}()
        for prop in props
          for compId in compIds
            push!(propvals, calculate(prop,gettemppropdata(proppackage,prop,compId)))
          end
        end
        return propvals
    end

#***********************************************
  function getconstpropdata(proppackage::PropertyPackage, prop::ASCIIString, compId::Int)
    data::Array{Union{AbstractString,Float64,Int},2}
    if haskey(proppackage.constantstrings, prop) 
      data=proppackage.propertytable[proppackage.constantstrings[prop]]
    elseif haskey(proppackage.constantfloats, prop) 
      data=proppackage.propertytable[proppackage.constantfloats[prop]]
    end 
    return data[findfirst(data[:,1],compId),:]
  end
  
  function getdataeqno(data::Array{Float64,2}, prop::ASCIIString)
    (prop in["idealGasEntropy","idealGasEnthalpy","volumeOfLiquid","heatCapacityOfLiquid","idealGasHeatCapacity"]) && (return data[i,3:end-1],data[i,end])
    return data[i,3:end],0
  end
   
  function gettemppropdata(proppackage::PropertyPackage, prop::ASCIIString, compId::Int)
    data::Array{Float64,2}
    ret::Vector{TempPropData}
    ret=Vector{TempPropData}()
    data=proppackage.propertytable[proppackage.tempreturedependents[prop]]
    datarange=getdataeqno(data,prop)
    for i in data[:,1]
      if i==compId
        tpd=TempPropData(prop,datarange[1],NaN,NaN,data[i,1],data[i,2],datarange[2])
        push!(ret,tpd)
      end
    end
    return ret
  end
end
