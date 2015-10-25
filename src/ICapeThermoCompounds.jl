module ICapeThermoCompounds
    export getconstproplist,gettdependentproplist,getpdependentproplist,getnumcompounds,getcompoundlist
    export getcompoundconstant,getpdependentproperty,gettdependentproperty
    using  PhysicalPropertyCalculator
    using  ThermodynamicsTable
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
        return  gettablesize("Compounds")
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

        compIds::Vector{UInt16}
        formulae::Vector{ASCIIString}
        names::Vector{ASCIIString}
        boilTemps::Vector{Float64}
        molwts::Vector{Float64}
        casnos::Vector{ASCIIString}

        size=gettablesize("Compounds")
        
        compIds=Vector{UInt16}(size)
        formulae=Vector{ASCIIString}(size)
        names=Vector{ASCIIString}(size)
        boilTemps=Vector{Float64}(size)
        molwts=Vector{Float64}(size)
        casnos=Vector{ASCIIString}(size)
        
        for id = 1%UInt16:size%UInt16
          compIds[id],data=readbinarydatabase(id,"Compounds")
          formulae[id]=data[2]
          names[id]=data[1]
          casnos[id]=data[3]
          molwts[id]=data[4]
          boilTemps[id]=data[5]
        end

        return compIds,formulae,names,boilTemps,molwts,casnos
    end

    """
      Returns the values of constant Physical Properties for the specified Compounds.
      #= [retval][out] =# propvals::Vector{Any}
    """
    function getcompoundconstant(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# compIds::Vector{UInt16}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Union{ASCIIString,Float64}}
        propvals=Vector{Union{ASCIIString,Float64}}()     
        for prop in props
          for compId in compIds            
            id,data=getconstpropdata(proppackage,prop,compId)
            push!(propvals, calculate(prop,data))
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
  #                 Privates
  #***********************************************
  function getconstpropdata(proppackage::PropertyPackage, prop::ASCIIString, compId::UInt16)
    table::ASCIIString
    if haskey(proppackage.constantstrings, prop) 
      table=proppackage.constantstrings[prop]
    elseif haskey(proppackage.constantfloats, prop) 
      table=proppackage.constantfloats[prop]
    end 
    return readbinarydatabase(compId,table)
  end
  
  function getdataeqno(data::Array{Float64,2}, prop::ASCIIString)
    (prop in["idealGasEntropy","idealGasEnthalpy","volumeOfLiquid","heatCapacityOfLiquid","idealGasHeatCapacity"]) && (return data[i,3:end-1],data[i,end])
    return data[i,2:end],0
  end
   
  function gettemppropdata(proppackage::PropertyPackage, prop::ASCIIString, compId::UInt16)
    table::ASCIIString
    data::Vector{Float64}
    ret::Vector{TempPropData}
    ret=Vector{TempPropData}()
    table=proppackage.propertytable[proppackage.tempreturedependents[prop]]
    compId,data=readbinarydatabase(table,compId)
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
