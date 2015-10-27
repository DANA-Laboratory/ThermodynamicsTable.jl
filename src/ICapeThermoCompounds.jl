"""
Methods implemented by components that need to describe the Compounds that occur or can occur in a Material.

getcompoundlist()
getcompoundconstant!()
getconstproplist()
getnumcompounds()
getpdependentproperty()
getpdependentproplist()
gettdependentproperty()
gettdependentproplist()

"""
module ICapeThermoCompounds
    export getconstproplist,gettdependentproplist,getpdependentproplist,getnumcompounds,getcompoundlist
    export getcompoundconstant!,getpdependentproperty,gettdependentproperty
    using  ThermodynamicsTable,PhysicalPropertyCalculator,ECapeExceptions
    import CapeOpen.PropertyPackage
    import PhysicalPropertyCalculator.TempPropData
    """
      Description
        Returns the list of supported constant Physical Properties.
      Arguments
        [in] proppackage::PropertyPackage
        [retval] props::Vector{ASCIIString}
      Exceptions
        ECapeUnknown – The error to be raised when other error(s), specified for the GetConstPropList operation, are not suitable.
    """
    function getconstproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        try
          props = [keys(proppackage.constantstrings)...; keys(proppackage.constantfloats)...]
          return props
        catch
          throw(ECapeUnknown())
        end
    end

    """
      Description
        Returns the list of supported temperature-dependent Physical Properties.
      Arguments
        [in] proppackage::PropertyPackage
        [retval]props::Vector{ASCIIString}
      Exceptions
        ECapeUnknown – The error to be raised when other error(s), specified for the GetConstPropList operation, are not suitable.
    """
    function gettdependentproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        try
          props = [keys(proppackage.tempreturedependents)...]
          return props
        catch
          throw(ECapeUnknown())
        end
    end

    """
      Description
        Returns the list of supported pressure-dependent properties.
      Arguments
        [in] proppackage::PropertyPackage
        [retval]props::Vector{ASCIIString}
      Exceptions
        ECapeUnknown – The error to be raised when other error(s), specified for the GetConstPropList operation, are not suitable.
    """
    function getpdependentproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        try
          props = [keys(proppackage.pressuredependents)...]
          return props
        catch
          throw(ECapeUnknown())
        end
    end

    """
      Description
        Returns the number of Compounds supported.
      Arguments
        [in] proppackage::PropertyPackage
        [retval] num::Int32
      Exceptions
        ECapeUnknown – The error to be raised when other error(s), specified for the GetConstPropList operation, are not suitable.
    """
    function getnumcompounds(
        proppackage::PropertyPackage)
        try
          return  gettablesize("Compounds")
        catch
          throw(ECapeUnknown())
        end
    end

    """
      Description
        Returns the list of all Compounds. This includes the Compound identifiers recognised and extra information that can be used to further identify the Compounds.
      Arguments
        [in] proppackage::PropertyPackage
        [retval] compIds::Vector{ASCIIString} List of Compound identifiers.
        [retval] formulae::Vector{ASCIIString} List of Compound formulae.
        [retval] names::Vector{ASCIIString} List of Compound names.
        [retval] boilTemps::Vector{Float64} List of boiling point temperatures.
        [retval] molwts::Vector{Float64} List of molecular weights.
        [retval] casnos::Vector{ASCIIString}) List of Chemical Abstract Service (CAS) Registry numbers.
      Exceptions
        ECapeUnknown – The error to be raised when other error(s), specified for the GetConstPropList operation, are not suitable.
      Note
        If any item cannot be returned then the value should be set to "UNDEFINED",0%Int16,Float64(NaN) for different types.
    """
    function getcompoundlist(
        proppackage::PropertyPackage)
        try
          size=gettablesize("Compounds")        
          compIds=Vector{UInt16}(size)
          formulae=Vector{ASCIIString}(size)
          names=Vector{ASCIIString}(size)
          boilTemps=Vector{Float64}(size)
          molwts=Vector{Float64}(size)
          casnos=Vector{ASCIIString}(size)
          for id = 1:size
            compIds[id]=round(UInt16,id)
            data=readbinarydatabase(compIds[id],"Compounds",0%UInt8)
            formulae[id]=copy(data[2])
            names[id]=copy(data[1])
            casnos[id]=copy(data[3])
            molwts[id]=data[4]
            boilTemps[id]=data[5]
          end
          return compIds,formulae,names,boilTemps,molwts,casnos
        catch
          throw(ECapeUnknown())
        end
    end

    """
      Description
        Returns the values of constant Physical Properties for the specified Compounds.
      Arguments
        [in] props::Vector{ASCIIString},
        [in] compIds::Vector{UInt16}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to 0%UInt16 to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        [in out] propvals::Vector{Any}
      Exceptions
        ECapeThrmPropertyNotAvailable – At least one item in the list of Physical Properties is not available for a particular Compound. This exception is meant to be treated as a warning rather than as an error.
        ECapeLimitedImpl – One or more Physical Properties are not supported by the component that implements this interface. 
        This exception should also be raised if any element of the props argument is not recognised.
        ECapeInvalidArgument – To be used when an invalid argument value is passed, for example, an unrecognised Compound identifier or UNDEFINED for the props argument.
        ECapeUnknown – The error to be raised when other error(s), specified for the operation, are not suitable.
      Note
        The GetConstPropList method can be used in order to check which constant Physical Properties are available.
        If the number of requested Physical Properties is P and the number of Compounds is C, the propvals array will contain C*P variants. 
        The first C variants will be the values for the first requested Physical Property (one for each Compound) followed by C values of constants for the second Physical Property, and so on. 
        If the compIds argument is set to 0%UInt16 this is a request to return property values for all compounds in the component that implements the ICapeThermoCompounds interface with the compound order the same as that returned by the GetCompoundList method.
        If any Physical Property is not available for one or more Compounds, then "UNDEFINED",Float64(NaN) values must be returned for those combinations and an ECapeThrmPropertyNotAvailable exception must be raised.
    """
    function getcompoundconstant!(
        proppackage::PropertyPackage,
        props::Vector{ASCIIString},
        compIds::Vector{UInt16},
        propvals::Vector{Union{ASCIIString,Float64}})
        thrownotavailable::Bool=false
        (compIds==[0%UInt16]) && compIds=[i for i=1%UInt16:345%UInt16]
        allprops=getconstproplist(proppackage)
        try
          for prop in props
            !(prop in allprops) && throw(ECapeInvalidArgument())
            for compId in compIds            
              (compId>345%UInt16 || compId==0%UInt16) && throw(ECapeInvalidArgument())
              data=getconstpropdata(proppackage,prop,compId)
              propval=calculate(prop,data)
              push!(propvals, propval)
              isnan(propval) && throw(ECapeThrmPropertyNotAvailable())
            end
          end
        catch err
          if isa(err,ECapeThrmPropertyNotAvailable)
            thrownotavailable=true
          elseif isa(err,ECapeInvalidArgument)
            throw(err)
          elseif isa(err,ECapeLimitedImpl)
            throw(err)
          else
            throw(ECapeUnknown())
          end
        end
        thrownotavailable && throw(ECapeThrmPropertyNotAvailable()) 
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
        #= [in] =# compIds::Vector{UInt16}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Float64}
        propvals=Vector{Float64}()
        
        for prop in props
          for compId in compIds
          
            temppropdata::TempPropData
            
            temppropdata=TempPropData(proppackage,prop,compId)
            temppropdata.t=temperature

            try
              push!(propvals, calculate(temppropdata))
            catch err
              if isa(err,ECapeOutOfBounds)
                push!(propvals, NaN)
              else
                dump(temppropdata)
                throw(err)
              end
            end
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
    return readbinarydatabase(compId,table,0%UInt8)
  end
   
  function TempPropData(proppackage::PropertyPackage, prop::ASCIIString, compId::UInt16, skipdata::UInt8=0%UInt8)
    table::ASCIIString
    floatdata::Vector{Float64}
    temppropdata::TempPropData
    table=proppackage.tempreturedependents[prop]
    data=readbinarydatabase(compId,table,skipdata)
    floatdata=data[1]
    temppropdata=TempPropData(prop,floatdata[2:end],compId,floatdata[1])
    if (prop in["idealGasEntropy","idealGasEnthalpy","volumeOfLiquid","heatCapacityOfLiquid","idealGasHeatCapacity"]) 
      temppropdata.eqno=data[2]
    end
    if (prop in["heatCapacityOfLiquid","heatOfVaporization"])
      temppropdata.tc=calculate(prop,getconstpropdata(proppackage,"criticalTemperature",compId))
    end
    if (prop in ["heatCapacityOfLiquid","heatOfVaporization","idealGasHeatCapacity","thermalConductivityOfLiquid","vaporPressure","viscosityOfLiquid"])
      temppropdata.test=temppropdata.c[6:9]
    elseif (prop in ["thermalConductivityOfVapor","viscosityOfVapor","volumeOfLiquid"])
      temppropdata.test=temppropdata.c[5:8]
    elseif (prop in ["idealGasEnthalpy", "idealGasEntropy"])
      temppropdata.test=[temppropdata.c[6],NaN,temppropdata.c[8],NaN]
    end
    return temppropdata
  end
end
