
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  Call_LocationsList_567880 = ref object of OpenApiRestCall_567658
proc url_LocationsList_567882(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LocationsList_567881(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568054 = query.getOrDefault("api-version")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568054 != nil:
    section.add "api-version", valid_568054
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568055 = header.getOrDefault("Accept-Language")
  valid_568055 = validateParameter(valid_568055, JString, required = false,
                                 default = nil)
  if valid_568055 != nil:
    section.add "Accept-Language", valid_568055
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_LocationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_LocationsList_567880;
          apiVersion: string = "2016-11-01"): Recallable =
  ## locationsList
  ## Returns a list of locations to which you can ship the disks associated with an import or export job. A location is a Microsoft data center region.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  var query_568150 = newJObject()
  add(query_568150, "api-version", newJString(apiVersion))
  result = call_568149.call(nil, query_568150, nil, nil, nil)

var locationsList* = Call_LocationsList_567880(name: "locationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/locations",
    validator: validate_LocationsList_567881, base: "", url: url_LocationsList_567882,
    schemes: {Scheme.Https})
type
  Call_LocationsGet_568190 = ref object of OpenApiRestCall_567658
proc url_LocationsGet_568192(protocol: Scheme; host: string; base: string;
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

proc validate_LocationsGet_568191(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568207 = path.getOrDefault("locationName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "locationName", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568209 = header.getOrDefault("Accept-Language")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "Accept-Language", valid_568209
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_LocationsGet_568190; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_LocationsGet_568190; locationName: string;
          apiVersion: string = "2016-11-01"): Recallable =
  ## locationsGet
  ## Returns the details about a location to which you can ship the disks associated with an import or export job. A location is an Azure region.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  ##   locationName: string (required)
  ##               : The name of the location. For example, West US or westus.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "locationName", newJString(locationName))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var locationsGet* = Call_LocationsGet_568190(name: "locationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/locations/{locationName}",
    validator: validate_LocationsGet_568191, base: "", url: url_LocationsGet_568192,
    schemes: {Scheme.Https})
type
  Call_OperationsList_568214 = ref object of OpenApiRestCall_567658
proc url_OperationsList_568216(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568215(path: JsonNode; query: JsonNode;
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
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568218 = header.getOrDefault("Accept-Language")
  valid_568218 = validateParameter(valid_568218, JString, required = false,
                                 default = nil)
  if valid_568218 != nil:
    section.add "Accept-Language", valid_568218
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_OperationsList_568214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of operations supported by the import/export resource provider.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_OperationsList_568214;
          apiVersion: string = "2016-11-01"): Recallable =
  ## operationsList
  ## Returns the list of operations supported by the import/export resource provider.
  ##   apiVersion: string (required)
  ##             : Specifies the API version to use for this request.
  var query_568221 = newJObject()
  add(query_568221, "api-version", newJString(apiVersion))
  result = call_568220.call(nil, query_568221, nil, nil, nil)

var operationsList* = Call_OperationsList_568214(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ImportExport/operations",
    validator: validate_OperationsList_568215, base: "", url: url_OperationsList_568216,
    schemes: {Scheme.Https})
type
  Call_JobsListBySubscription_568222 = ref object of OpenApiRestCall_567658
proc url_JobsListBySubscription_568224(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListBySubscription_568223(path: JsonNode; query: JsonNode;
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
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
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
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  var valid_568228 = query.getOrDefault("$top")
  valid_568228 = validateParameter(valid_568228, JInt, required = false, default = nil)
  if valid_568228 != nil:
    section.add "$top", valid_568228
  var valid_568229 = query.getOrDefault("$filter")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "$filter", valid_568229
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568230 = header.getOrDefault("Accept-Language")
  valid_568230 = validateParameter(valid_568230, JString, required = false,
                                 default = nil)
  if valid_568230 != nil:
    section.add "Accept-Language", valid_568230
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_JobsListBySubscription_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all active and completed jobs in a subscription.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_JobsListBySubscription_568222; subscriptionId: string;
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
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(query_568234, "$top", newJInt(Top))
  add(query_568234, "$filter", newJString(Filter))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var jobsListBySubscription* = Call_JobsListBySubscription_568222(
    name: "jobsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ImportExport/jobs",
    validator: validate_JobsListBySubscription_568223, base: "",
    url: url_JobsListBySubscription_568224, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_568235 = ref object of OpenApiRestCall_567658
proc url_JobsListByResourceGroup_568237(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByResourceGroup_568236(path: JsonNode; query: JsonNode;
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
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
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
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  var valid_568241 = query.getOrDefault("$top")
  valid_568241 = validateParameter(valid_568241, JInt, required = false, default = nil)
  if valid_568241 != nil:
    section.add "$top", valid_568241
  var valid_568242 = query.getOrDefault("$filter")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "$filter", valid_568242
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568243 = header.getOrDefault("Accept-Language")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "Accept-Language", valid_568243
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_JobsListByResourceGroup_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all active and completed jobs in a resource group.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_JobsListByResourceGroup_568235;
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
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(query_568247, "$top", newJInt(Top))
  add(query_568247, "$filter", newJString(Filter))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_568235(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs",
    validator: validate_JobsListByResourceGroup_568236, base: "",
    url: url_JobsListByResourceGroup_568237, schemes: {Scheme.Https})
type
  Call_JobsCreate_568260 = ref object of OpenApiRestCall_567658
proc url_JobsCreate_568262(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCreate_568261(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("subscriptionId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "subscriptionId", valid_568281
  var valid_568282 = path.getOrDefault("jobName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "jobName", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568283 != nil:
    section.add "api-version", valid_568283
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  ##   x-ms-client-tenant-id: JString
  ##                        : The tenant ID of the client making the request.
  section = newJObject()
  var valid_568284 = header.getOrDefault("Accept-Language")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "Accept-Language", valid_568284
  var valid_568285 = header.getOrDefault("x-ms-client-tenant-id")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "x-ms-client-tenant-id", valid_568285
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

proc call*(call_568287: Call_JobsCreate_568260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job or updates an existing job in the specified subscription.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_JobsCreate_568260; resourceGroupName: string;
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
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  var body_568291 = newJObject()
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  add(path_568289, "jobName", newJString(jobName))
  if body != nil:
    body_568291 = body
  result = call_568288.call(path_568289, query_568290, nil, nil, body_568291)

var jobsCreate* = Call_JobsCreate_568260(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsCreate_568261,
                                      base: "", url: url_JobsCreate_568262,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_568248 = ref object of OpenApiRestCall_567658
proc url_JobsGet_568250(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_568249(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("jobName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "jobName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568255 = header.getOrDefault("Accept-Language")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "Accept-Language", valid_568255
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_JobsGet_568248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an existing job.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_JobsGet_568248; resourceGroupName: string;
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
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  add(path_568258, "jobName", newJString(jobName))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var jobsGet* = Call_JobsGet_568248(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                validator: validate_JobsGet_568249, base: "",
                                url: url_JobsGet_568250, schemes: {Scheme.Https})
type
  Call_JobsUpdate_568304 = ref object of OpenApiRestCall_567658
proc url_JobsUpdate_568306(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsUpdate_568305(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("jobName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "jobName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568311 = header.getOrDefault("Accept-Language")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "Accept-Language", valid_568311
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

proc call*(call_568313: Call_JobsUpdate_568304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates specific properties of a job. You can call this operation to notify the Import/Export service that the hard drives comprising the import or export job have been shipped to the Microsoft data center. It can also be used to cancel an existing job.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_JobsUpdate_568304; resourceGroupName: string;
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
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  var body_568317 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "jobName", newJString(jobName))
  if body != nil:
    body_568317 = body
  result = call_568314.call(path_568315, query_568316, nil, nil, body_568317)

var jobsUpdate* = Call_JobsUpdate_568304(name: "jobsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsUpdate_568305,
                                      base: "", url: url_JobsUpdate_568306,
                                      schemes: {Scheme.Https})
type
  Call_JobsDelete_568292 = ref object of OpenApiRestCall_567658
proc url_JobsDelete_568294(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_568293(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568295 = path.getOrDefault("resourceGroupName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "resourceGroupName", valid_568295
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  var valid_568297 = path.getOrDefault("jobName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "jobName", valid_568297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568299 = header.getOrDefault("Accept-Language")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "Accept-Language", valid_568299
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_JobsDelete_568292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing job. Only jobs in the Creating or Completed states can be deleted.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_JobsDelete_568292; resourceGroupName: string;
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
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "jobName", newJString(jobName))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_568292(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}",
                                      validator: validate_JobsDelete_568293,
                                      base: "", url: url_JobsDelete_568294,
                                      schemes: {Scheme.Https})
type
  Call_BitLockerKeysList_568318 = ref object of OpenApiRestCall_567658
proc url_BitLockerKeysList_568320(protocol: Scheme; host: string; base: string;
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

proc validate_BitLockerKeysList_568319(path: JsonNode; query: JsonNode;
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
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  var valid_568323 = path.getOrDefault("jobName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "jobName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version to use for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = newJString("2016-11-01"))
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Specifies the preferred language for the response.
  section = newJObject()
  var valid_568325 = header.getOrDefault("Accept-Language")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "Accept-Language", valid_568325
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_BitLockerKeysList_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the BitLocker Keys for all drives in the specified job.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_BitLockerKeysList_568318; resourceGroupName: string;
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
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "jobName", newJString(jobName))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var bitLockerKeysList* = Call_BitLockerKeysList_568318(name: "bitLockerKeysList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ImportExport/jobs/{jobName}/listBitLockerKeys",
    validator: validate_BitLockerKeysList_568319, base: "",
    url: url_BitLockerKeysList_568320, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
