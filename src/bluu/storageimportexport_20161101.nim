
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "storageimportexport"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LocationsList_563778 = ref object of OpenApiRestCall_563556
proc url_LocationsList_563780(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LocationsList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563954 = query.getOrDefault("api-version")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_563954 != nil:
    section.add "api-version", valid_563954
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_563955 = header.getOrDefault("Accept-Language")
  valid_563955 = validateParameter(valid_563955, JString, required = false,
                                 default = nil)
  if valid_563955 != nil:
    section.add "Accept-Language", valid_563955
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_LocationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_LocationsList_563778;
          apiVersion: string = "2016-11-01"): Recallable =
  ## locationsList
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  var query_564050 = newJObject()
  add(query_564050, "api-version", newJString(apiVersion))
  result = call_564049.call(nil, query_564050, nil, nil, nil)

var locationsList* = Call_LocationsList_563778(name: "locationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/locations",
    validator: validate_LocationsList_563779, base: "", url: url_LocationsList_563780,
    schemes: {Scheme.Https})
type
  Call_LocationsGet_564090 = ref object of OpenApiRestCall_563556
proc url_LocationsGet_564092(protocol: Scheme; host: string; base: string;
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

proc validate_LocationsGet_564091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564107 = path.getOrDefault("locationName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "locationName", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564109 = header.getOrDefault("Accept-Language")
  valid_564109 = validateParameter(valid_564109, JString, required = false,
                                 default = nil)
  if valid_564109 != nil:
    section.add "Accept-Language", valid_564109
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_LocationsGet_564090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_LocationsGet_564090; locationName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## locationsGet
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   locationName: string (required)
  ##               : The name of the location. For example, West US or westus.
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(query_564113, "api-version", newJString(apiVersion))
  add(path_564112, "locationName", newJString(locationName))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var locationsGet* = Call_LocationsGet_564090(name: "locationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/locations/{locationName}",
    validator: validate_LocationsGet_564091, base: "", url: url_LocationsGet_564092,
    schemes: {Scheme.Https})
type
  Call_OperationsList_564114 = ref object of OpenApiRestCall_563556
proc url_OperationsList_564116(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564115(path: JsonNode; query: JsonNode;
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
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564118 = header.getOrDefault("Accept-Language")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "Accept-Language", valid_564118
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_OperationsList_564114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of operations supported by the import/export resource provider.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_OperationsList_564114;
          apiVersion: string = "2016-11-01"): Recallable =
  ## operationsList
  ## Returns the list of operations supported by the import/export resource provider.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  var query_564121 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  result = call_564120.call(nil, query_564121, nil, nil, nil)

var operationsList* = Call_OperationsList_564114(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/operations",
    validator: validate_OperationsList_564115, base: "", url: url_OperationsList_564116,
    schemes: {Scheme.Https})
type
  Call_JobsListBySubscription_564122 = ref object of OpenApiRestCall_563556
proc url_JobsListBySubscription_564124(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListBySubscription_564123(path: JsonNode; query: JsonNode;
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
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  ##   $filter: JString
  ##          : Can be used to restrict the results to certain conditions.
  section = newJObject()
  var valid_564127 = query.getOrDefault("$top")
  valid_564127 = validateParameter(valid_564127, JInt, required = false, default = nil)
  if valid_564127 != nil:
    section.add "$top", valid_564127
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  var valid_564129 = query.getOrDefault("$filter")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "$filter", valid_564129
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564130 = header.getOrDefault("Accept-Language")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = nil)
  if valid_564130 != nil:
    section.add "Accept-Language", valid_564130
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_JobsListBySubscription_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all active and completed jobs in a subscription.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_JobsListBySubscription_564122; subscriptionId: string;
          Top: int = 0; apiVersion: string = "2016-11-01"; Filter: string = ""): Recallable =
  ## jobsListBySubscription
  ## Returns all active and completed jobs in a subscription.
  ##   Top: int
  ##      : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   Filter: string
  ##         : Can be used to restrict the results to certain conditions.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "$top", newJInt(Top))
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(query_564134, "$filter", newJString(Filter))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var jobsListBySubscription* = Call_JobsListBySubscription_564122(
    name: "jobsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ImportExport/jobs",
    validator: validate_JobsListBySubscription_564123, base: "",
    url: url_JobsListBySubscription_564124, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_564135 = ref object of OpenApiRestCall_563556
proc url_JobsListByResourceGroup_564137(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByResourceGroup_564136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all active and completed jobs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("resourceGroupName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceGroupName", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  ##   $filter: JString
  ##          : Can be used to restrict the results to certain conditions.
  section = newJObject()
  var valid_564140 = query.getOrDefault("$top")
  valid_564140 = validateParameter(valid_564140, JInt, required = false, default = nil)
  if valid_564140 != nil:
    section.add "$top", valid_564140
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  var valid_564142 = query.getOrDefault("$filter")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "$filter", valid_564142
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564143 = header.getOrDefault("Accept-Language")
  valid_564143 = validateParameter(valid_564143, JString, required = false,
                                 default = nil)
  if valid_564143 != nil:
    section.add "Accept-Language", valid_564143
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_JobsListByResourceGroup_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all active and completed jobs in a resource group.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_JobsListByResourceGroup_564135;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-11-01"; Filter: string = ""): Recallable =
  ## jobsListByResourceGroup
  ## Returns all active and completed jobs in a resource group.
  ##   Top: int
  ##      : An integer value that specifies how many jobs at most should be returned. The value cannot exceed 100.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   Filter: string
  ##         : Can be used to restrict the results to certain conditions.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "$top", newJInt(Top))
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  add(query_564147, "$filter", newJString(Filter))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_564135(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs",
    validator: validate_JobsListByResourceGroup_564136, base: "",
    url: url_JobsListByResourceGroup_564137, schemes: {Scheme.Https})
type
  Call_JobsCreate_564160 = ref object of OpenApiRestCall_563556
proc url_JobsCreate_564162(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCreate_564161(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job or updates an existing job in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("jobName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "jobName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  ##   x-ms-client-tenant-id: JString
  ##                        : The tenant ID of the client making the request.
  section = newJObject()
  var valid_564184 = header.getOrDefault("Accept-Language")
  valid_564184 = validateParameter(valid_564184, JString, required = false,
                                 default = nil)
  if valid_564184 != nil:
    section.add "Accept-Language", valid_564184
  var valid_564185 = header.getOrDefault("x-ms-client-tenant-id")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = nil)
  if valid_564185 != nil:
    section.add "x-ms-client-tenant-id", valid_564185
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

proc call*(call_564187: Call_JobsCreate_564160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job or updates an existing job in the specified subscription.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_JobsCreate_564160; subscriptionId: string;
          resourceGroupName: string; body: JsonNode; jobName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## jobsCreate
  ## Creates a new job or updates an existing job in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   body: JObject (required)
  ##       : The parameters used for creating the job
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  var body_564191 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564191 = body
  add(path_564189, "jobName", newJString(jobName))
  result = call_564188.call(path_564189, query_564190, nil, nil, body_564191)

var jobsCreate* = Call_JobsCreate_564160(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsCreate_564161,
                                      base: "", url: url_JobsCreate_564162,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_564148 = ref object of OpenApiRestCall_563556
proc url_JobsGet_564150(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_564149(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  var valid_564153 = path.getOrDefault("jobName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "jobName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564155 = header.getOrDefault("Accept-Language")
  valid_564155 = validateParameter(valid_564155, JString, required = false,
                                 default = nil)
  if valid_564155 != nil:
    section.add "Accept-Language", valid_564155
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_JobsGet_564148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an existing job.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_JobsGet_564148; subscriptionId: string;
          resourceGroupName: string; jobName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## jobsGet
  ## Gets information about an existing job.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  add(path_564158, "jobName", newJString(jobName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var jobsGet* = Call_JobsGet_564148(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                validator: validate_JobsGet_564149, base: "",
                                url: url_JobsGet_564150, schemes: {Scheme.Https})
type
  Call_JobsUpdate_564204 = ref object of OpenApiRestCall_563556
proc url_JobsUpdate_564206(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsUpdate_564205(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("jobName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "jobName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564211 = header.getOrDefault("Accept-Language")
  valid_564211 = validateParameter(valid_564211, JString, required = false,
                                 default = nil)
  if valid_564211 != nil:
    section.add "Accept-Language", valid_564211
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

proc call*(call_564213: Call_JobsUpdate_564204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_JobsUpdate_564204; subscriptionId: string;
          resourceGroupName: string; body: JsonNode; jobName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## jobsUpdate
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   body: JObject (required)
  ##       : The parameters to update in the job
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  var body_564217 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564217 = body
  add(path_564215, "jobName", newJString(jobName))
  result = call_564214.call(path_564215, query_564216, nil, nil, body_564217)

var jobsUpdate* = Call_JobsUpdate_564204(name: "jobsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsUpdate_564205,
                                      base: "", url: url_JobsUpdate_564206,
                                      schemes: {Scheme.Https})
type
  Call_JobsDelete_564192 = ref object of OpenApiRestCall_563556
proc url_JobsDelete_564194(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_564193(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  var valid_564197 = path.getOrDefault("jobName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "jobName", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564199 = header.getOrDefault("Accept-Language")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "Accept-Language", valid_564199
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_JobsDelete_564192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_JobsDelete_564192; subscriptionId: string;
          resourceGroupName: string; jobName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## jobsDelete
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  add(path_564202, "jobName", newJString(jobName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_564192(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsDelete_564193,
                                      base: "", url: url_JobsDelete_564194,
                                      schemes: {Scheme.Https})
type
  Call_BitLockerKeysList_564218 = ref object of OpenApiRestCall_563556
proc url_BitLockerKeysList_564220(protocol: Scheme; host: string; base: string;
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

proc validate_BitLockerKeysList_564219(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the BitLocker Keys for all drives in the specified job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: JString (required)
  ##          : The name of the import/export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  var valid_564223 = path.getOrDefault("jobName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "jobName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_564225 = header.getOrDefault("Accept-Language")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "Accept-Language", valid_564225
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_BitLockerKeysList_564218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the BitLocker Keys for all drives in the specified job.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_BitLockerKeysList_564218; subscriptionId: string;
          resourceGroupName: string; jobName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## bitLockerKeysList
  ## Returns the BitLocker Keys for all drives in the specified job.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID for the Azure user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscription.
  ##   jobName: string (required)
  ##          : The name of the import/export job.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  add(path_564228, "jobName", newJString(jobName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var bitLockerKeysList* = Call_BitLockerKeysList_564218(name: "bitLockerKeysList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}/listBitLockerKeys",
    validator: validate_BitLockerKeysList_564219, base: "",
    url: url_BitLockerKeysList_564220, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
