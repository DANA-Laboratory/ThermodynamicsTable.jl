module ECapeExceptions
     
    type ECapeBoundaries <: Exception end
    type ECapeRoot <: Exception end
    type ECapeUser <: Exception end
    type ECapeUnknown <: Exception end
    type ECapeData <: Exception end
    type ECapeLicenceError <: Exception end
    type ECapeBadCOParameter <: Exception end
    type ECapeBadArgument <: Exception end
    type ECapeInvalidArgument <: Exception end
    type ECapeOutOfBounds <: Exception end
    type ECapeImplementation <: Exception end
    type ECapeNoImpl <: Exception end
    type ECapeLimitedImpl <: Exception end
    type ECapeComputation <: Exception end
    type ECapeOutOfResources <: Exception end
    type ECapeNoMemory <: Exception end
    type ECapeTimeOut <: Exception end
    type ECapeFailedInitialisation <: Exception end
    type ECapeSolvingError <: Exception end
    type ECapeBadInvOrder <: Exception end
    type ECapeInvalidOperation <: Exception end
    type ECapePersistence <: Exception end
    type ECapeIllegalAccess <: Exception end
    type ECapePersistenceNotFound <: Exception end
    type ECapePersistenceSystemError <: Exception end
    type ECapePersistenceOverflow <: Exception end
    type ECapeErrorDummy <: Exception end
    type ECapeThrmPropertyNotAvailable <: Exception end
    
end
