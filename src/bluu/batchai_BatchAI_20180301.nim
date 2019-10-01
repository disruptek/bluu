
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchAI
## version: 2018-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure BatchAI Management API.
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

  OpenApiRestCall_574466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574466): Option[Scheme] {.used.} =
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
  macServiceName = "batchai-BatchAI"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_574688 = ref object of OpenApiRestCall_574466
proc url_OperationsList_574690(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574689(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.BatchAI provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574849 = query.getOrDefault("api-version")
  valid_574849 = validateParameter(valid_574849, JString, required = true,
                                 default = nil)
  if valid_574849 != nil:
    section.add "api-version", valid_574849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574872: Call_OperationsList_574688; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.BatchAI provider.
  ## 
  let valid = call_574872.validator(path, query, header, formData, body)
  let scheme = call_574872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574872.url(scheme.get, call_574872.host, call_574872.base,
                         call_574872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574872, url, valid)

proc call*(call_574943: Call_OperationsList_574688; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.BatchAI provider.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  var query_574944 = newJObject()
  add(query_574944, "api-version", newJString(apiVersion))
  result = call_574943.call(nil, query_574944, nil, nil, nil)

var operationsList* = Call_OperationsList_574688(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.BatchAI/operations",
    validator: validate_OperationsList_574689, base: "", url: url_OperationsList_574690,
    schemes: {Scheme.Https})
type
  Call_ClustersList_574984 = ref object of OpenApiRestCall_574466
proc url_ClustersList_574986(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersList_574985(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the Clusters associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575002 = path.getOrDefault("subscriptionId")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "subscriptionId", valid_575002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575003 = query.getOrDefault("api-version")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "api-version", valid_575003
  var valid_575018 = query.getOrDefault("maxresults")
  valid_575018 = validateParameter(valid_575018, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575018 != nil:
    section.add "maxresults", valid_575018
  var valid_575019 = query.getOrDefault("$select")
  valid_575019 = validateParameter(valid_575019, JString, required = false,
                                 default = nil)
  if valid_575019 != nil:
    section.add "$select", valid_575019
  var valid_575020 = query.getOrDefault("$filter")
  valid_575020 = validateParameter(valid_575020, JString, required = false,
                                 default = nil)
  if valid_575020 != nil:
    section.add "$filter", valid_575020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575021: Call_ClustersList_574984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Clusters associated with the subscription.
  ## 
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_ClustersList_574984; apiVersion: string;
          subscriptionId: string; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## clustersList
  ## Gets information about the Clusters associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Select: string
  ##         : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   Filter: string
  ##         : An OData $filter clause. Used to filter results that are returned in the GET response.
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "subscriptionId", newJString(subscriptionId))
  add(query_575024, "maxresults", newJInt(maxresults))
  add(query_575024, "$select", newJString(Select))
  add(query_575024, "$filter", newJString(Filter))
  result = call_575022.call(path_575023, query_575024, nil, nil, nil)

var clustersList* = Call_ClustersList_574984(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BatchAI/clusters",
    validator: validate_ClustersList_574985, base: "", url: url_ClustersList_574986,
    schemes: {Scheme.Https})
type
  Call_FileServersList_575025 = ref object of OpenApiRestCall_574466
proc url_FileServersList_575027(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/fileServers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersList_575026(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## To list all the file servers available under the given subscription (and across all resource groups within that subscription)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575028 = path.getOrDefault("subscriptionId")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "subscriptionId", valid_575028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575029 = query.getOrDefault("api-version")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "api-version", valid_575029
  var valid_575030 = query.getOrDefault("maxresults")
  valid_575030 = validateParameter(valid_575030, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575030 != nil:
    section.add "maxresults", valid_575030
  var valid_575031 = query.getOrDefault("$select")
  valid_575031 = validateParameter(valid_575031, JString, required = false,
                                 default = nil)
  if valid_575031 != nil:
    section.add "$select", valid_575031
  var valid_575032 = query.getOrDefault("$filter")
  valid_575032 = validateParameter(valid_575032, JString, required = false,
                                 default = nil)
  if valid_575032 != nil:
    section.add "$filter", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575033: Call_FileServersList_575025; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To list all the file servers available under the given subscription (and across all resource groups within that subscription)
  ## 
  let valid = call_575033.validator(path, query, header, formData, body)
  let scheme = call_575033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575033.url(scheme.get, call_575033.host, call_575033.base,
                         call_575033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575033, url, valid)

proc call*(call_575034: Call_FileServersList_575025; apiVersion: string;
          subscriptionId: string; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## fileServersList
  ## To list all the file servers available under the given subscription (and across all resource groups within that subscription)
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Select: string
  ##         : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   Filter: string
  ##         : An OData $filter clause. Used to filter results that are returned in the GET response.
  var path_575035 = newJObject()
  var query_575036 = newJObject()
  add(query_575036, "api-version", newJString(apiVersion))
  add(path_575035, "subscriptionId", newJString(subscriptionId))
  add(query_575036, "maxresults", newJInt(maxresults))
  add(query_575036, "$select", newJString(Select))
  add(query_575036, "$filter", newJString(Filter))
  result = call_575034.call(path_575035, query_575036, nil, nil, nil)

var fileServersList* = Call_FileServersList_575025(name: "fileServersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BatchAI/fileServers",
    validator: validate_FileServersList_575026, base: "", url: url_FileServersList_575027,
    schemes: {Scheme.Https})
type
  Call_JobsList_575037 = ref object of OpenApiRestCall_574466
proc url_JobsList_575039(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsList_575038(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the jobs associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575040 = path.getOrDefault("subscriptionId")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "subscriptionId", valid_575040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575041 = query.getOrDefault("api-version")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "api-version", valid_575041
  var valid_575042 = query.getOrDefault("maxresults")
  valid_575042 = validateParameter(valid_575042, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575042 != nil:
    section.add "maxresults", valid_575042
  var valid_575043 = query.getOrDefault("$select")
  valid_575043 = validateParameter(valid_575043, JString, required = false,
                                 default = nil)
  if valid_575043 != nil:
    section.add "$select", valid_575043
  var valid_575044 = query.getOrDefault("$filter")
  valid_575044 = validateParameter(valid_575044, JString, required = false,
                                 default = nil)
  if valid_575044 != nil:
    section.add "$filter", valid_575044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575045: Call_JobsList_575037; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the jobs associated with the subscription.
  ## 
  let valid = call_575045.validator(path, query, header, formData, body)
  let scheme = call_575045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575045.url(scheme.get, call_575045.host, call_575045.base,
                         call_575045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575045, url, valid)

proc call*(call_575046: Call_JobsList_575037; apiVersion: string;
          subscriptionId: string; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## jobsList
  ## Gets information about the jobs associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Select: string
  ##         : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   Filter: string
  ##         : An OData $filter clause. Used to filter results that are returned in the GET response.
  var path_575047 = newJObject()
  var query_575048 = newJObject()
  add(query_575048, "api-version", newJString(apiVersion))
  add(path_575047, "subscriptionId", newJString(subscriptionId))
  add(query_575048, "maxresults", newJInt(maxresults))
  add(query_575048, "$select", newJString(Select))
  add(query_575048, "$filter", newJString(Filter))
  result = call_575046.call(path_575047, query_575048, nil, nil, nil)

var jobsList* = Call_JobsList_575037(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BatchAI/jobs",
                                  validator: validate_JobsList_575038, base: "",
                                  url: url_JobsList_575039,
                                  schemes: {Scheme.Https})
type
  Call_UsageList_575049 = ref object of OpenApiRestCall_574466
proc url_UsageList_575051(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageList_575050(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage information as well as limits for Batch AI resources for given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575052 = path.getOrDefault("subscriptionId")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "subscriptionId", valid_575052
  var valid_575053 = path.getOrDefault("location")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "location", valid_575053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575054 = query.getOrDefault("api-version")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "api-version", valid_575054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575055: Call_UsageList_575049; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage information as well as limits for Batch AI resources for given subscription.
  ## 
  let valid = call_575055.validator(path, query, header, formData, body)
  let scheme = call_575055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575055.url(scheme.get, call_575055.host, call_575055.base,
                         call_575055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575055, url, valid)

proc call*(call_575056: Call_UsageList_575049; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets the current usage information as well as limits for Batch AI resources for given subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_575057 = newJObject()
  var query_575058 = newJObject()
  add(query_575058, "api-version", newJString(apiVersion))
  add(path_575057, "subscriptionId", newJString(subscriptionId))
  add(path_575057, "location", newJString(location))
  result = call_575056.call(path_575057, query_575058, nil, nil, nil)

var usageList* = Call_UsageList_575049(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BatchAI/locations/{location}/usages",
                                    validator: validate_UsageList_575050,
                                    base: "", url: url_UsageList_575051,
                                    schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_575059 = ref object of OpenApiRestCall_574466
proc url_ClustersListByResourceGroup_575061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListByResourceGroup_575060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the Clusters associated within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575062 = path.getOrDefault("resourceGroupName")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "resourceGroupName", valid_575062
  var valid_575063 = path.getOrDefault("subscriptionId")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "subscriptionId", valid_575063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575064 = query.getOrDefault("api-version")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "api-version", valid_575064
  var valid_575065 = query.getOrDefault("maxresults")
  valid_575065 = validateParameter(valid_575065, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575065 != nil:
    section.add "maxresults", valid_575065
  var valid_575066 = query.getOrDefault("$select")
  valid_575066 = validateParameter(valid_575066, JString, required = false,
                                 default = nil)
  if valid_575066 != nil:
    section.add "$select", valid_575066
  var valid_575067 = query.getOrDefault("$filter")
  valid_575067 = validateParameter(valid_575067, JString, required = false,
                                 default = nil)
  if valid_575067 != nil:
    section.add "$filter", valid_575067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575068: Call_ClustersListByResourceGroup_575059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Clusters associated within the specified resource group.
  ## 
  let valid = call_575068.validator(path, query, header, formData, body)
  let scheme = call_575068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575068.url(scheme.get, call_575068.host, call_575068.base,
                         call_575068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575068, url, valid)

proc call*(call_575069: Call_ClustersListByResourceGroup_575059;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          maxresults: int = 1000; Select: string = ""; Filter: string = ""): Recallable =
  ## clustersListByResourceGroup
  ## Gets information about the Clusters associated within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Select: string
  ##         : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   Filter: string
  ##         : An OData $filter clause. Used to filter results that are returned in the GET response.
  var path_575070 = newJObject()
  var query_575071 = newJObject()
  add(path_575070, "resourceGroupName", newJString(resourceGroupName))
  add(query_575071, "api-version", newJString(apiVersion))
  add(path_575070, "subscriptionId", newJString(subscriptionId))
  add(query_575071, "maxresults", newJInt(maxresults))
  add(query_575071, "$select", newJString(Select))
  add(query_575071, "$filter", newJString(Filter))
  result = call_575069.call(path_575070, query_575071, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_575059(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters",
    validator: validate_ClustersListByResourceGroup_575060, base: "",
    url: url_ClustersListByResourceGroup_575061, schemes: {Scheme.Https})
type
  Call_ClustersCreate_575083 = ref object of OpenApiRestCall_574466
proc url_ClustersCreate_575085(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersCreate_575084(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds a cluster. A cluster is a collection of compute nodes. Multiple jobs can be run on the same cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575103 = path.getOrDefault("clusterName")
  valid_575103 = validateParameter(valid_575103, JString, required = true,
                                 default = nil)
  if valid_575103 != nil:
    section.add "clusterName", valid_575103
  var valid_575104 = path.getOrDefault("resourceGroupName")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "resourceGroupName", valid_575104
  var valid_575105 = path.getOrDefault("subscriptionId")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "subscriptionId", valid_575105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575106 = query.getOrDefault("api-version")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "api-version", valid_575106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for cluster creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575108: Call_ClustersCreate_575083; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a cluster. A cluster is a collection of compute nodes. Multiple jobs can be run on the same cluster.
  ## 
  let valid = call_575108.validator(path, query, header, formData, body)
  let scheme = call_575108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575108.url(scheme.get, call_575108.host, call_575108.base,
                         call_575108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575108, url, valid)

proc call*(call_575109: Call_ClustersCreate_575083; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## clustersCreate
  ## Adds a cluster. A cluster is a collection of compute nodes. Multiple jobs can be run on the same cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for cluster creation.
  var path_575110 = newJObject()
  var query_575111 = newJObject()
  var body_575112 = newJObject()
  add(path_575110, "clusterName", newJString(clusterName))
  add(path_575110, "resourceGroupName", newJString(resourceGroupName))
  add(query_575111, "api-version", newJString(apiVersion))
  add(path_575110, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575112 = parameters
  result = call_575109.call(path_575110, query_575111, nil, nil, body_575112)

var clustersCreate* = Call_ClustersCreate_575083(name: "clustersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
    validator: validate_ClustersCreate_575084, base: "", url: url_ClustersCreate_575085,
    schemes: {Scheme.Https})
type
  Call_ClustersGet_575072 = ref object of OpenApiRestCall_574466
proc url_ClustersGet_575074(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersGet_575073(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575075 = path.getOrDefault("clusterName")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "clusterName", valid_575075
  var valid_575076 = path.getOrDefault("resourceGroupName")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "resourceGroupName", valid_575076
  var valid_575077 = path.getOrDefault("subscriptionId")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "subscriptionId", valid_575077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575078 = query.getOrDefault("api-version")
  valid_575078 = validateParameter(valid_575078, JString, required = true,
                                 default = nil)
  if valid_575078 != nil:
    section.add "api-version", valid_575078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575079: Call_ClustersGet_575072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Cluster.
  ## 
  let valid = call_575079.validator(path, query, header, formData, body)
  let scheme = call_575079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575079.url(scheme.get, call_575079.host, call_575079.base,
                         call_575079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575079, url, valid)

proc call*(call_575080: Call_ClustersGet_575072; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersGet
  ## Gets information about the specified Cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  var path_575081 = newJObject()
  var query_575082 = newJObject()
  add(path_575081, "clusterName", newJString(clusterName))
  add(path_575081, "resourceGroupName", newJString(resourceGroupName))
  add(query_575082, "api-version", newJString(apiVersion))
  add(path_575081, "subscriptionId", newJString(subscriptionId))
  result = call_575080.call(path_575081, query_575082, nil, nil, nil)

var clustersGet* = Call_ClustersGet_575072(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
                                        validator: validate_ClustersGet_575073,
                                        base: "", url: url_ClustersGet_575074,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_575124 = ref object of OpenApiRestCall_574466
proc url_ClustersUpdate_575126(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersUpdate_575125(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the properties of a given cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575127 = path.getOrDefault("clusterName")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "clusterName", valid_575127
  var valid_575128 = path.getOrDefault("resourceGroupName")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "resourceGroupName", valid_575128
  var valid_575129 = path.getOrDefault("subscriptionId")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "subscriptionId", valid_575129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575130 = query.getOrDefault("api-version")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "api-version", valid_575130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575132: Call_ClustersUpdate_575124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the properties of a given cluster.
  ## 
  let valid = call_575132.validator(path, query, header, formData, body)
  let scheme = call_575132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575132.url(scheme.get, call_575132.host, call_575132.base,
                         call_575132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575132, url, valid)

proc call*(call_575133: Call_ClustersUpdate_575124; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## clustersUpdate
  ## Update the properties of a given cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  var path_575134 = newJObject()
  var query_575135 = newJObject()
  var body_575136 = newJObject()
  add(path_575134, "clusterName", newJString(clusterName))
  add(path_575134, "resourceGroupName", newJString(resourceGroupName))
  add(query_575135, "api-version", newJString(apiVersion))
  add(path_575134, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575136 = parameters
  result = call_575133.call(path_575134, query_575135, nil, nil, body_575136)

var clustersUpdate* = Call_ClustersUpdate_575124(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
    validator: validate_ClustersUpdate_575125, base: "", url: url_ClustersUpdate_575126,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_575113 = ref object of OpenApiRestCall_574466
proc url_ClustersDelete_575115(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersDelete_575114(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575116 = path.getOrDefault("clusterName")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "clusterName", valid_575116
  var valid_575117 = path.getOrDefault("resourceGroupName")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "resourceGroupName", valid_575117
  var valid_575118 = path.getOrDefault("subscriptionId")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "subscriptionId", valid_575118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575119 = query.getOrDefault("api-version")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "api-version", valid_575119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575120: Call_ClustersDelete_575113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cluster.
  ## 
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_ClustersDelete_575113; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersDelete
  ## Deletes a Cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  add(path_575122, "clusterName", newJString(clusterName))
  add(path_575122, "resourceGroupName", newJString(resourceGroupName))
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "subscriptionId", newJString(subscriptionId))
  result = call_575121.call(path_575122, query_575123, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_575113(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
    validator: validate_ClustersDelete_575114, base: "", url: url_ClustersDelete_575115,
    schemes: {Scheme.Https})
type
  Call_ClustersListRemoteLoginInformation_575137 = ref object of OpenApiRestCall_574466
proc url_ClustersListRemoteLoginInformation_575139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/listRemoteLoginInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListRemoteLoginInformation_575138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IP address, port of all the compute nodes in the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_575140 = path.getOrDefault("clusterName")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "clusterName", valid_575140
  var valid_575141 = path.getOrDefault("resourceGroupName")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "resourceGroupName", valid_575141
  var valid_575142 = path.getOrDefault("subscriptionId")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "subscriptionId", valid_575142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575143 = query.getOrDefault("api-version")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "api-version", valid_575143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575144: Call_ClustersListRemoteLoginInformation_575137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address, port of all the compute nodes in the cluster.
  ## 
  let valid = call_575144.validator(path, query, header, formData, body)
  let scheme = call_575144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575144.url(scheme.get, call_575144.host, call_575144.base,
                         call_575144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575144, url, valid)

proc call*(call_575145: Call_ClustersListRemoteLoginInformation_575137;
          clusterName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersListRemoteLoginInformation
  ## Get the IP address, port of all the compute nodes in the cluster.
  ##   clusterName: string (required)
  ##              : The name of the cluster within the specified resource group. Cluster names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  var path_575146 = newJObject()
  var query_575147 = newJObject()
  add(path_575146, "clusterName", newJString(clusterName))
  add(path_575146, "resourceGroupName", newJString(resourceGroupName))
  add(query_575147, "api-version", newJString(apiVersion))
  add(path_575146, "subscriptionId", newJString(subscriptionId))
  result = call_575145.call(path_575146, query_575147, nil, nil, nil)

var clustersListRemoteLoginInformation* = Call_ClustersListRemoteLoginInformation_575137(
    name: "clustersListRemoteLoginInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}/listRemoteLoginInformation",
    validator: validate_ClustersListRemoteLoginInformation_575138, base: "",
    url: url_ClustersListRemoteLoginInformation_575139, schemes: {Scheme.Https})
type
  Call_FileServersListByResourceGroup_575148 = ref object of OpenApiRestCall_574466
proc url_FileServersListByResourceGroup_575150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/fileServers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListByResourceGroup_575149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a formatted list of file servers and their properties associated within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575151 = path.getOrDefault("resourceGroupName")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "resourceGroupName", valid_575151
  var valid_575152 = path.getOrDefault("subscriptionId")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "subscriptionId", valid_575152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575153 = query.getOrDefault("api-version")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "api-version", valid_575153
  var valid_575154 = query.getOrDefault("maxresults")
  valid_575154 = validateParameter(valid_575154, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575154 != nil:
    section.add "maxresults", valid_575154
  var valid_575155 = query.getOrDefault("$select")
  valid_575155 = validateParameter(valid_575155, JString, required = false,
                                 default = nil)
  if valid_575155 != nil:
    section.add "$select", valid_575155
  var valid_575156 = query.getOrDefault("$filter")
  valid_575156 = validateParameter(valid_575156, JString, required = false,
                                 default = nil)
  if valid_575156 != nil:
    section.add "$filter", valid_575156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575157: Call_FileServersListByResourceGroup_575148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a formatted list of file servers and their properties associated within the specified resource group.
  ## 
  let valid = call_575157.validator(path, query, header, formData, body)
  let scheme = call_575157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575157.url(scheme.get, call_575157.host, call_575157.base,
                         call_575157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575157, url, valid)

proc call*(call_575158: Call_FileServersListByResourceGroup_575148;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          maxresults: int = 1000; Select: string = ""; Filter: string = ""): Recallable =
  ## fileServersListByResourceGroup
  ## Gets a formatted list of file servers and their properties associated within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Select: string
  ##         : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   Filter: string
  ##         : An OData $filter clause. Used to filter results that are returned in the GET response.
  var path_575159 = newJObject()
  var query_575160 = newJObject()
  add(path_575159, "resourceGroupName", newJString(resourceGroupName))
  add(query_575160, "api-version", newJString(apiVersion))
  add(path_575159, "subscriptionId", newJString(subscriptionId))
  add(query_575160, "maxresults", newJInt(maxresults))
  add(query_575160, "$select", newJString(Select))
  add(query_575160, "$filter", newJString(Filter))
  result = call_575158.call(path_575159, query_575160, nil, nil, nil)

var fileServersListByResourceGroup* = Call_FileServersListByResourceGroup_575148(
    name: "fileServersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers",
    validator: validate_FileServersListByResourceGroup_575149, base: "",
    url: url_FileServersListByResourceGroup_575150, schemes: {Scheme.Https})
type
  Call_FileServersCreate_575172 = ref object of OpenApiRestCall_574466
proc url_FileServersCreate_575174(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/fileServers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersCreate_575173(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a file server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: JString (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575175 = path.getOrDefault("resourceGroupName")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "resourceGroupName", valid_575175
  var valid_575176 = path.getOrDefault("subscriptionId")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "subscriptionId", valid_575176
  var valid_575177 = path.getOrDefault("fileServerName")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "fileServerName", valid_575177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575178 = query.getOrDefault("api-version")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "api-version", valid_575178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for file server creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575180: Call_FileServersCreate_575172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a file server.
  ## 
  let valid = call_575180.validator(path, query, header, formData, body)
  let scheme = call_575180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575180.url(scheme.get, call_575180.host, call_575180.base,
                         call_575180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575180, url, valid)

proc call*(call_575181: Call_FileServersCreate_575172; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          fileServerName: string): Recallable =
  ## fileServersCreate
  ## Creates a file server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for file server creation.
  ##   fileServerName: string (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575182 = newJObject()
  var query_575183 = newJObject()
  var body_575184 = newJObject()
  add(path_575182, "resourceGroupName", newJString(resourceGroupName))
  add(query_575183, "api-version", newJString(apiVersion))
  add(path_575182, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575184 = parameters
  add(path_575182, "fileServerName", newJString(fileServerName))
  result = call_575181.call(path_575182, query_575183, nil, nil, body_575184)

var fileServersCreate* = Call_FileServersCreate_575172(name: "fileServersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers/{fileServerName}",
    validator: validate_FileServersCreate_575173, base: "",
    url: url_FileServersCreate_575174, schemes: {Scheme.Https})
type
  Call_FileServersGet_575161 = ref object of OpenApiRestCall_574466
proc url_FileServersGet_575163(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/fileServers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersGet_575162(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified Cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: JString (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575164 = path.getOrDefault("resourceGroupName")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "resourceGroupName", valid_575164
  var valid_575165 = path.getOrDefault("subscriptionId")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "subscriptionId", valid_575165
  var valid_575166 = path.getOrDefault("fileServerName")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "fileServerName", valid_575166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575167 = query.getOrDefault("api-version")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "api-version", valid_575167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575168: Call_FileServersGet_575161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Cluster.
  ## 
  let valid = call_575168.validator(path, query, header, formData, body)
  let scheme = call_575168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575168.url(scheme.get, call_575168.host, call_575168.base,
                         call_575168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575168, url, valid)

proc call*(call_575169: Call_FileServersGet_575161; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; fileServerName: string): Recallable =
  ## fileServersGet
  ## Gets information about the specified Cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: string (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575170 = newJObject()
  var query_575171 = newJObject()
  add(path_575170, "resourceGroupName", newJString(resourceGroupName))
  add(query_575171, "api-version", newJString(apiVersion))
  add(path_575170, "subscriptionId", newJString(subscriptionId))
  add(path_575170, "fileServerName", newJString(fileServerName))
  result = call_575169.call(path_575170, query_575171, nil, nil, nil)

var fileServersGet* = Call_FileServersGet_575161(name: "fileServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers/{fileServerName}",
    validator: validate_FileServersGet_575162, base: "", url: url_FileServersGet_575163,
    schemes: {Scheme.Https})
type
  Call_FileServersDelete_575185 = ref object of OpenApiRestCall_574466
proc url_FileServersDelete_575187(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/fileServers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersDelete_575186(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete a file Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: JString (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575188 = path.getOrDefault("resourceGroupName")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "resourceGroupName", valid_575188
  var valid_575189 = path.getOrDefault("subscriptionId")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "subscriptionId", valid_575189
  var valid_575190 = path.getOrDefault("fileServerName")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "fileServerName", valid_575190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575191 = query.getOrDefault("api-version")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "api-version", valid_575191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575192: Call_FileServersDelete_575185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a file Server.
  ## 
  let valid = call_575192.validator(path, query, header, formData, body)
  let scheme = call_575192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575192.url(scheme.get, call_575192.host, call_575192.base,
                         call_575192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575192, url, valid)

proc call*(call_575193: Call_FileServersDelete_575185; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; fileServerName: string): Recallable =
  ## fileServersDelete
  ## Delete a file Server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   fileServerName: string (required)
  ##                 : The name of the file server within the specified resource group. File server names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575194 = newJObject()
  var query_575195 = newJObject()
  add(path_575194, "resourceGroupName", newJString(resourceGroupName))
  add(query_575195, "api-version", newJString(apiVersion))
  add(path_575194, "subscriptionId", newJString(subscriptionId))
  add(path_575194, "fileServerName", newJString(fileServerName))
  result = call_575193.call(path_575194, query_575195, nil, nil, nil)

var fileServersDelete* = Call_FileServersDelete_575185(name: "fileServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers/{fileServerName}",
    validator: validate_FileServersDelete_575186, base: "",
    url: url_FileServersDelete_575187, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_575196 = ref object of OpenApiRestCall_574466
proc url_JobsListByResourceGroup_575198(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByResourceGroup_575197(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the Batch AI jobs associated within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575199 = path.getOrDefault("resourceGroupName")
  valid_575199 = validateParameter(valid_575199, JString, required = true,
                                 default = nil)
  if valid_575199 != nil:
    section.add "resourceGroupName", valid_575199
  var valid_575200 = path.getOrDefault("subscriptionId")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "subscriptionId", valid_575200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575201 = query.getOrDefault("api-version")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "api-version", valid_575201
  var valid_575202 = query.getOrDefault("maxresults")
  valid_575202 = validateParameter(valid_575202, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575202 != nil:
    section.add "maxresults", valid_575202
  var valid_575203 = query.getOrDefault("$select")
  valid_575203 = validateParameter(valid_575203, JString, required = false,
                                 default = nil)
  if valid_575203 != nil:
    section.add "$select", valid_575203
  var valid_575204 = query.getOrDefault("$filter")
  valid_575204 = validateParameter(valid_575204, JString, required = false,
                                 default = nil)
  if valid_575204 != nil:
    section.add "$filter", valid_575204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575205: Call_JobsListByResourceGroup_575196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Batch AI jobs associated within the specified resource group.
  ## 
  let valid = call_575205.validator(path, query, header, formData, body)
  let scheme = call_575205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575205.url(scheme.get, call_575205.host, call_575205.base,
                         call_575205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575205, url, valid)

proc call*(call_575206: Call_JobsListByResourceGroup_575196;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          maxresults: int = 1000; Select: string = ""; Filter: string = ""): Recallable =
  ## jobsListByResourceGroup
  ## Gets information about the Batch AI jobs associated within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Select: string
  ##         : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   Filter: string
  ##         : An OData $filter clause. Used to filter results that are returned in the GET response.
  var path_575207 = newJObject()
  var query_575208 = newJObject()
  add(path_575207, "resourceGroupName", newJString(resourceGroupName))
  add(query_575208, "api-version", newJString(apiVersion))
  add(path_575207, "subscriptionId", newJString(subscriptionId))
  add(query_575208, "maxresults", newJInt(maxresults))
  add(query_575208, "$select", newJString(Select))
  add(query_575208, "$filter", newJString(Filter))
  result = call_575206.call(path_575207, query_575208, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_575196(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs",
    validator: validate_JobsListByResourceGroup_575197, base: "",
    url: url_JobsListByResourceGroup_575198, schemes: {Scheme.Https})
type
  Call_JobsCreate_575220 = ref object of OpenApiRestCall_574466
proc url_JobsCreate_575222(protocol: Scheme; host: string; base: string; route: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCreate_575221(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a Job that gets executed on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575223 = path.getOrDefault("resourceGroupName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "resourceGroupName", valid_575223
  var valid_575224 = path.getOrDefault("subscriptionId")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "subscriptionId", valid_575224
  var valid_575225 = path.getOrDefault("jobName")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "jobName", valid_575225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575226 = query.getOrDefault("api-version")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "api-version", valid_575226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for job creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575228: Call_JobsCreate_575220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a Job that gets executed on a cluster.
  ## 
  let valid = call_575228.validator(path, query, header, formData, body)
  let scheme = call_575228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575228.url(scheme.get, call_575228.host, call_575228.base,
                         call_575228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575228, url, valid)

proc call*(call_575229: Call_JobsCreate_575220; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          parameters: JsonNode): Recallable =
  ## jobsCreate
  ## Adds a Job that gets executed on a cluster.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for job creation.
  var path_575230 = newJObject()
  var query_575231 = newJObject()
  var body_575232 = newJObject()
  add(path_575230, "resourceGroupName", newJString(resourceGroupName))
  add(query_575231, "api-version", newJString(apiVersion))
  add(path_575230, "subscriptionId", newJString(subscriptionId))
  add(path_575230, "jobName", newJString(jobName))
  if parameters != nil:
    body_575232 = parameters
  result = call_575229.call(path_575230, query_575231, nil, nil, body_575232)

var jobsCreate* = Call_JobsCreate_575220(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}",
                                      validator: validate_JobsCreate_575221,
                                      base: "", url: url_JobsCreate_575222,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_575209 = ref object of OpenApiRestCall_574466
proc url_JobsGet_575211(protocol: Scheme; host: string; base: string; route: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_575210(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified Batch AI job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575212 = path.getOrDefault("resourceGroupName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "resourceGroupName", valid_575212
  var valid_575213 = path.getOrDefault("subscriptionId")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "subscriptionId", valid_575213
  var valid_575214 = path.getOrDefault("jobName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "jobName", valid_575214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575215 = query.getOrDefault("api-version")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "api-version", valid_575215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575216: Call_JobsGet_575209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Batch AI job.
  ## 
  let valid = call_575216.validator(path, query, header, formData, body)
  let scheme = call_575216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575216.url(scheme.get, call_575216.host, call_575216.base,
                         call_575216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575216, url, valid)

proc call*(call_575217: Call_JobsGet_575209; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobsGet
  ## Gets information about the specified Batch AI job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575218 = newJObject()
  var query_575219 = newJObject()
  add(path_575218, "resourceGroupName", newJString(resourceGroupName))
  add(query_575219, "api-version", newJString(apiVersion))
  add(path_575218, "subscriptionId", newJString(subscriptionId))
  add(path_575218, "jobName", newJString(jobName))
  result = call_575217.call(path_575218, query_575219, nil, nil, nil)

var jobsGet* = Call_JobsGet_575209(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}",
                                validator: validate_JobsGet_575210, base: "",
                                url: url_JobsGet_575211, schemes: {Scheme.Https})
type
  Call_JobsDelete_575233 = ref object of OpenApiRestCall_574466
proc url_JobsDelete_575235(protocol: Scheme; host: string; base: string; route: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsDelete_575234(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Batch AI job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575236 = path.getOrDefault("resourceGroupName")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "resourceGroupName", valid_575236
  var valid_575237 = path.getOrDefault("subscriptionId")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = nil)
  if valid_575237 != nil:
    section.add "subscriptionId", valid_575237
  var valid_575238 = path.getOrDefault("jobName")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "jobName", valid_575238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575239 = query.getOrDefault("api-version")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "api-version", valid_575239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575240: Call_JobsDelete_575233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Batch AI job.
  ## 
  let valid = call_575240.validator(path, query, header, formData, body)
  let scheme = call_575240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575240.url(scheme.get, call_575240.host, call_575240.base,
                         call_575240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575240, url, valid)

proc call*(call_575241: Call_JobsDelete_575233; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobsDelete
  ## Deletes the specified Batch AI job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575242 = newJObject()
  var query_575243 = newJObject()
  add(path_575242, "resourceGroupName", newJString(resourceGroupName))
  add(query_575243, "api-version", newJString(apiVersion))
  add(path_575242, "subscriptionId", newJString(subscriptionId))
  add(path_575242, "jobName", newJString(jobName))
  result = call_575241.call(path_575242, query_575243, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_575233(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}",
                                      validator: validate_JobsDelete_575234,
                                      base: "", url: url_JobsDelete_575235,
                                      schemes: {Scheme.Https})
type
  Call_JobsListOutputFiles_575244 = ref object of OpenApiRestCall_574466
proc url_JobsListOutputFiles_575246(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/listOutputFiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListOutputFiles_575245(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all directories and files inside the given directory of the output directory (Only if the output directory is on Azure File Share or Azure Storage container).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575247 = path.getOrDefault("resourceGroupName")
  valid_575247 = validateParameter(valid_575247, JString, required = true,
                                 default = nil)
  if valid_575247 != nil:
    section.add "resourceGroupName", valid_575247
  var valid_575248 = path.getOrDefault("subscriptionId")
  valid_575248 = validateParameter(valid_575248, JString, required = true,
                                 default = nil)
  if valid_575248 != nil:
    section.add "subscriptionId", valid_575248
  var valid_575249 = path.getOrDefault("jobName")
  valid_575249 = validateParameter(valid_575249, JString, required = true,
                                 default = nil)
  if valid_575249 != nil:
    section.add "jobName", valid_575249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   directory: JString
  ##            : The path to the directory.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   linkexpiryinminutes: JInt
  ##                      : The number of minutes after which the download link will expire.
  ##   outputdirectoryid: JString (required)
  ##                    : Id of the job output directory. This is the OutputDirectory-->id parameter that is given by the user during Create Job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575250 = query.getOrDefault("api-version")
  valid_575250 = validateParameter(valid_575250, JString, required = true,
                                 default = nil)
  if valid_575250 != nil:
    section.add "api-version", valid_575250
  var valid_575251 = query.getOrDefault("directory")
  valid_575251 = validateParameter(valid_575251, JString, required = false,
                                 default = newJString("."))
  if valid_575251 != nil:
    section.add "directory", valid_575251
  var valid_575252 = query.getOrDefault("maxresults")
  valid_575252 = validateParameter(valid_575252, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575252 != nil:
    section.add "maxresults", valid_575252
  var valid_575253 = query.getOrDefault("linkexpiryinminutes")
  valid_575253 = validateParameter(valid_575253, JInt, required = false,
                                 default = newJInt(60))
  if valid_575253 != nil:
    section.add "linkexpiryinminutes", valid_575253
  var valid_575254 = query.getOrDefault("outputdirectoryid")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "outputdirectoryid", valid_575254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575255: Call_JobsListOutputFiles_575244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all directories and files inside the given directory of the output directory (Only if the output directory is on Azure File Share or Azure Storage container).
  ## 
  let valid = call_575255.validator(path, query, header, formData, body)
  let scheme = call_575255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575255.url(scheme.get, call_575255.host, call_575255.base,
                         call_575255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575255, url, valid)

proc call*(call_575256: Call_JobsListOutputFiles_575244; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          outputdirectoryid: string; directory: string = "."; maxresults: int = 1000;
          linkexpiryinminutes: int = 60): Recallable =
  ## jobsListOutputFiles
  ## List all directories and files inside the given directory of the output directory (Only if the output directory is on Azure File Share or Azure Storage container).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   directory: string
  ##            : The path to the directory.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   linkexpiryinminutes: int
  ##                      : The number of minutes after which the download link will expire.
  ##   outputdirectoryid: string (required)
  ##                    : Id of the job output directory. This is the OutputDirectory-->id parameter that is given by the user during Create Job.
  var path_575257 = newJObject()
  var query_575258 = newJObject()
  add(path_575257, "resourceGroupName", newJString(resourceGroupName))
  add(query_575258, "api-version", newJString(apiVersion))
  add(query_575258, "directory", newJString(directory))
  add(path_575257, "subscriptionId", newJString(subscriptionId))
  add(path_575257, "jobName", newJString(jobName))
  add(query_575258, "maxresults", newJInt(maxresults))
  add(query_575258, "linkexpiryinminutes", newJInt(linkexpiryinminutes))
  add(query_575258, "outputdirectoryid", newJString(outputdirectoryid))
  result = call_575256.call(path_575257, query_575258, nil, nil, nil)

var jobsListOutputFiles* = Call_JobsListOutputFiles_575244(
    name: "jobsListOutputFiles", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}/listOutputFiles",
    validator: validate_JobsListOutputFiles_575245, base: "",
    url: url_JobsListOutputFiles_575246, schemes: {Scheme.Https})
type
  Call_JobsListRemoteLoginInformation_575259 = ref object of OpenApiRestCall_574466
proc url_JobsListRemoteLoginInformation_575261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/listRemoteLoginInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListRemoteLoginInformation_575260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the IP address and port information of all the compute nodes which are used for job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575262 = path.getOrDefault("resourceGroupName")
  valid_575262 = validateParameter(valid_575262, JString, required = true,
                                 default = nil)
  if valid_575262 != nil:
    section.add "resourceGroupName", valid_575262
  var valid_575263 = path.getOrDefault("subscriptionId")
  valid_575263 = validateParameter(valid_575263, JString, required = true,
                                 default = nil)
  if valid_575263 != nil:
    section.add "subscriptionId", valid_575263
  var valid_575264 = path.getOrDefault("jobName")
  valid_575264 = validateParameter(valid_575264, JString, required = true,
                                 default = nil)
  if valid_575264 != nil:
    section.add "jobName", valid_575264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575265 = query.getOrDefault("api-version")
  valid_575265 = validateParameter(valid_575265, JString, required = true,
                                 default = nil)
  if valid_575265 != nil:
    section.add "api-version", valid_575265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575266: Call_JobsListRemoteLoginInformation_575259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the IP address and port information of all the compute nodes which are used for job execution.
  ## 
  let valid = call_575266.validator(path, query, header, formData, body)
  let scheme = call_575266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575266.url(scheme.get, call_575266.host, call_575266.base,
                         call_575266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575266, url, valid)

proc call*(call_575267: Call_JobsListRemoteLoginInformation_575259;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string): Recallable =
  ## jobsListRemoteLoginInformation
  ## Gets the IP address and port information of all the compute nodes which are used for job execution.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575268 = newJObject()
  var query_575269 = newJObject()
  add(path_575268, "resourceGroupName", newJString(resourceGroupName))
  add(query_575269, "api-version", newJString(apiVersion))
  add(path_575268, "subscriptionId", newJString(subscriptionId))
  add(path_575268, "jobName", newJString(jobName))
  result = call_575267.call(path_575268, query_575269, nil, nil, nil)

var jobsListRemoteLoginInformation* = Call_JobsListRemoteLoginInformation_575259(
    name: "jobsListRemoteLoginInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}/listRemoteLoginInformation",
    validator: validate_JobsListRemoteLoginInformation_575260, base: "",
    url: url_JobsListRemoteLoginInformation_575261, schemes: {Scheme.Https})
type
  Call_JobsTerminate_575270 = ref object of OpenApiRestCall_574466
proc url_JobsTerminate_575272(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.BatchAI/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/terminate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsTerminate_575271(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Terminates a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: JString (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575273 = path.getOrDefault("resourceGroupName")
  valid_575273 = validateParameter(valid_575273, JString, required = true,
                                 default = nil)
  if valid_575273 != nil:
    section.add "resourceGroupName", valid_575273
  var valid_575274 = path.getOrDefault("subscriptionId")
  valid_575274 = validateParameter(valid_575274, JString, required = true,
                                 default = nil)
  if valid_575274 != nil:
    section.add "subscriptionId", valid_575274
  var valid_575275 = path.getOrDefault("jobName")
  valid_575275 = validateParameter(valid_575275, JString, required = true,
                                 default = nil)
  if valid_575275 != nil:
    section.add "jobName", valid_575275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575276 = query.getOrDefault("api-version")
  valid_575276 = validateParameter(valid_575276, JString, required = true,
                                 default = nil)
  if valid_575276 != nil:
    section.add "api-version", valid_575276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575277: Call_JobsTerminate_575270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Terminates a job.
  ## 
  let valid = call_575277.validator(path, query, header, formData, body)
  let scheme = call_575277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575277.url(scheme.get, call_575277.host, call_575277.base,
                         call_575277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575277, url, valid)

proc call*(call_575278: Call_JobsTerminate_575270; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobsTerminate
  ## Terminates a job.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
  ##   subscriptionId: string (required)
  ##                 : The subscriptionID for the Azure user.
  ##   jobName: string (required)
  ##          : The name of the job within the specified resource group. Job names can only contain a combination of alphanumeric characters along with dash (-) and underscore (_). The name must be from 1 through 64 characters long.
  var path_575279 = newJObject()
  var query_575280 = newJObject()
  add(path_575279, "resourceGroupName", newJString(resourceGroupName))
  add(query_575280, "api-version", newJString(apiVersion))
  add(path_575279, "subscriptionId", newJString(subscriptionId))
  add(path_575279, "jobName", newJString(jobName))
  result = call_575278.call(path_575279, query_575280, nil, nil, nil)

var jobsTerminate* = Call_JobsTerminate_575270(name: "jobsTerminate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}/terminate",
    validator: validate_JobsTerminate_575271, base: "", url: url_JobsTerminate_575272,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
