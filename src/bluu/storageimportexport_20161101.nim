
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageImportExport
## version: 2016-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Storage Import/Export Resource Provider API.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "storageimportexport"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LocationsList_593647 = ref object of OpenApiRestCall_593425
proc url_LocationsList_593649(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LocationsList_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_593822 = header.getOrDefault("Accept-Language")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "Accept-Language", valid_593822
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_LocationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_LocationsList_593647;
          apiVersion: string = "2016-11-01"): Recallable =
  ## locationsList
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var locationsList* = Call_LocationsList_593647(name: "locationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/locations",
    validator: validate_LocationsList_593648, base: "", url: url_LocationsList_593649,
    schemes: {Scheme.Https})
type
  Call_LocationsGet_593957 = ref object of OpenApiRestCall_593425
proc url_LocationsGet_593959(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ImportExport/locations/"),
               (kind: VariableSegment, value: "locationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGet_593958(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The name of the location. For example, West US or westus.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_593974 = path.getOrDefault("locationName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "locationName", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_593976 = header.getOrDefault("Accept-Language")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "Accept-Language", valid_593976
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_LocationsGet_593957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_LocationsGet_593957; locationName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## locationsGet
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   locationName: string (required)
  ##               : The name of the location. For example, West US or westus.
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "locationName", newJString(locationName))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var locationsGet* = Call_LocationsGet_593957(name: "locationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/locations/{locationName}",
    validator: validate_LocationsGet_593958, base: "", url: url_LocationsGet_593959,
    schemes: {Scheme.Https})
type
  Call_OperationsList_593981 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593983(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593982(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the list of operations supported by the import/export resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_593985 = header.getOrDefault("Accept-Language")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "Accept-Language", valid_593985
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_OperationsList_593981; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of operations supported by the import/export resource provider.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_OperationsList_593981;
          apiVersion: string = "2016-11-01"): Recallable =
  ## operationsList
  ## Returns the list of operations supported by the import/export resource provider.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  var query_593988 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  result = call_593987.call(nil, query_593988, nil, nil, nil)

var operationsList* = Call_OperationsList_593981(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/operations",
    validator: validate_OperationsList_593982, base: "", url: url_OperationsList_593983,
    schemes: {Scheme.Https})
type
  Call_JobsListBySubscription_593989 = ref object of OpenApiRestCall_593425
proc url_JobsListBySubscription_593991(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListBySubscription_593990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all active and completed jobs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  ##   $top: JInt
  ##       : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   $filter: JString
  ##          : Can be used to restrict the results to certain conditions.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  var valid_593995 = query.getOrDefault("$top")
  valid_593995 = validateParameter(valid_593995, JInt, required = false, default = nil)
  if valid_593995 != nil:
    section.add "$top", valid_593995
  var valid_593996 = query.getOrDefault("$filter")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$filter", valid_593996
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_593997 = header.getOrDefault("Accept-Language")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "Accept-Language", valid_593997
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_JobsListBySubscription_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all active and completed jobs in a subscription.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_JobsListBySubscription_593989; subscriptionId: string;
          apiVersion: string = "2016-11-01"; Top: int = 0; Filter: string = ""): Recallable =
  ## jobsListBySubscription
  ## Returns all active and completed jobs in a subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   Top: int
  ##      : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   Filter: string
  ##         : Can be used to restrict the results to certain conditions.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(query_594001, "$top", newJInt(Top))
  add(query_594001, "$filter", newJString(Filter))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var jobsListBySubscription* = Call_JobsListBySubscription_593989(
    name: "jobsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ImportExport/jobs",
    validator: validate_JobsListBySubscription_593990, base: "",
    url: url_JobsListBySubscription_593991, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_594002 = ref object of OpenApiRestCall_593425
proc url_JobsListByResourceGroup_594004(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByResourceGroup_594003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all active and completed jobs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  ##   $top: JInt
  ##       : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   $filter: JString
  ##          : Can be used to restrict the results to certain conditions.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  var valid_594008 = query.getOrDefault("$top")
  valid_594008 = validateParameter(valid_594008, JInt, required = false, default = nil)
  if valid_594008 != nil:
    section.add "$top", valid_594008
  var valid_594009 = query.getOrDefault("$filter")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$filter", valid_594009
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_594010 = header.getOrDefault("Accept-Language")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "Accept-Language", valid_594010
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_JobsListByResourceGroup_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all active and completed jobs in a resource group.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_JobsListByResourceGroup_594002;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2016-11-01"; Top: int = 0; Filter: string = ""): Recallable =
  ## jobsListByResourceGroup
  ## Returns all active and completed jobs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   Top: int
  ##      : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   Filter: string
  ##         : Can be used to restrict the results to certain conditions.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  add(query_594014, "$top", newJInt(Top))
  add(query_594014, "$filter", newJString(Filter))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_594002(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs",
    validator: validate_JobsListByResourceGroup_594003, base: "",
    url: url_JobsListByResourceGroup_594004, schemes: {Scheme.Https})
type
  Call_JobsCreate_594027 = ref object of OpenApiRestCall_593425
proc url_JobsCreate_594029(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCreate_594028(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job or updates an existing job in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  var valid_594049 = path.getOrDefault("jobName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "jobName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  ##   x-ms-client-tenant-id: JString
  ##                        : The tenant ID of the client making the request.
  section = newJObject()
  var valid_594051 = header.getOrDefault("Accept-Language")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "Accept-Language", valid_594051
  var valid_594052 = header.getOrDefault("x-ms-client-tenant-id")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "x-ms-client-tenant-id", valid_594052
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The parameters used for creating the job
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_JobsCreate_594027; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job or updates an existing job in the specified subscription.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_JobsCreate_594027; resourceGroupName: string;
          subscriptionId: string; jobName: string; body: JsonNode;
          apiVersion: string = "2016-11-01"): Recallable =
  ## jobsCreate
  ## Creates a new job or updates an existing job in the specified subscription.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  ##   body: JObject (required)
  ##       : The parameters used for creating the job
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  add(path_594056, "jobName", newJString(jobName))
  if body != nil:
    body_594058 = body
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var jobsCreate* = Call_JobsCreate_594027(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsCreate_594028,
                                      base: "", url: url_JobsCreate_594029,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_594015 = ref object of OpenApiRestCall_593425
proc url_JobsGet_594017(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_594016(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594018 = path.getOrDefault("resourceGroupName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceGroupName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("jobName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "jobName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_594022 = header.getOrDefault("Accept-Language")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "Accept-Language", valid_594022
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_JobsGet_594015; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an existing job.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_JobsGet_594015; resourceGroupName: string;
          subscriptionId: string; jobName: string; apiVersion: string = "2016-11-01"): Recallable =
  ## jobsGet
  ## Gets information about an existing job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  add(path_594025, "jobName", newJString(jobName))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var jobsGet* = Call_JobsGet_594015(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                validator: validate_JobsGet_594016, base: "",
                                url: url_JobsGet_594017, schemes: {Scheme.Https})
type
  Call_JobsUpdate_594071 = ref object of OpenApiRestCall_593425
proc url_JobsUpdate_594073(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsUpdate_594072(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("jobName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "jobName", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_594078 = header.getOrDefault("Accept-Language")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "Accept-Language", valid_594078
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The parameters to update in the job
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_JobsUpdate_594071; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_JobsUpdate_594071; resourceGroupName: string;
          subscriptionId: string; jobName: string; body: JsonNode;
          apiVersion: string = "2016-11-01"): Recallable =
  ## jobsUpdate
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  ##   body: JObject (required)
  ##       : The parameters to update in the job
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  var body_594084 = newJObject()
  add(path_594082, "resourceGroupName", newJString(resourceGroupName))
  add(query_594083, "api-version", newJString(apiVersion))
  add(path_594082, "subscriptionId", newJString(subscriptionId))
  add(path_594082, "jobName", newJString(jobName))
  if body != nil:
    body_594084 = body
  result = call_594081.call(path_594082, query_594083, nil, nil, body_594084)

var jobsUpdate* = Call_JobsUpdate_594071(name: "jobsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsUpdate_594072,
                                      base: "", url: url_JobsUpdate_594073,
                                      schemes: {Scheme.Https})
type
  Call_JobsDelete_594059 = ref object of OpenApiRestCall_593425
proc url_JobsDelete_594061(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsDelete_594060(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594062 = path.getOrDefault("resourceGroupName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "resourceGroupName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  var valid_594064 = path.getOrDefault("jobName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "jobName", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_594065 != nil:
    section.add "api-version", valid_594065
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_594066 = header.getOrDefault("Accept-Language")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "Accept-Language", valid_594066
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_JobsDelete_594059; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_JobsDelete_594059; resourceGroupName: string;
          subscriptionId: string; jobName: string; apiVersion: string = "2016-11-01"): Recallable =
  ## jobsDelete
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "jobName", newJString(jobName))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_594059(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsDelete_594060,
                                      base: "", url: url_JobsDelete_594061,
                                      schemes: {Scheme.Https})
type
  Call_BitLockerKeysList_594085 = ref object of OpenApiRestCall_593425
proc url_BitLockerKeysList_594087(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ImportExport/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/listBitLockerKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BitLockerKeysList_594086(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the BitLocker Keys for all drives in the specified job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("subscriptionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "subscriptionId", valid_594089
  var valid_594090 = path.getOrDefault("jobName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "jobName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_594092 = header.getOrDefault("Accept-Language")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "Accept-Language", valid_594092
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_BitLockerKeysList_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the BitLocker Keys for all drives in the specified job.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_BitLockerKeysList_594085; resourceGroupName: string;
          subscriptionId: string; jobName: string; apiVersion: string = "2016-11-01"): Recallable =
  ## bitLockerKeysList
  ## Returns the BitLocker Keys for all drives in the specified job.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "jobName", newJString(jobName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var bitLockerKeysList* = Call_BitLockerKeysList_594085(name: "bitLockerKeysList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}/listBitLockerKeys",
    validator: validate_BitLockerKeysList_594086, base: "",
    url: url_BitLockerKeysList_594087, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
