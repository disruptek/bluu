
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchAI
## version: 2017-09-01-preview
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
  Call_ClustersListByResourceGroup_575049 = ref object of OpenApiRestCall_574466
proc url_ClustersListByResourceGroup_575051(protocol: Scheme; host: string;
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

proc validate_ClustersListByResourceGroup_575050(path: JsonNode; query: JsonNode;
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
  var valid_575052 = path.getOrDefault("resourceGroupName")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "resourceGroupName", valid_575052
  var valid_575053 = path.getOrDefault("subscriptionId")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "subscriptionId", valid_575053
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
  var valid_575054 = query.getOrDefault("api-version")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "api-version", valid_575054
  var valid_575055 = query.getOrDefault("maxresults")
  valid_575055 = validateParameter(valid_575055, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575055 != nil:
    section.add "maxresults", valid_575055
  var valid_575056 = query.getOrDefault("$select")
  valid_575056 = validateParameter(valid_575056, JString, required = false,
                                 default = nil)
  if valid_575056 != nil:
    section.add "$select", valid_575056
  var valid_575057 = query.getOrDefault("$filter")
  valid_575057 = validateParameter(valid_575057, JString, required = false,
                                 default = nil)
  if valid_575057 != nil:
    section.add "$filter", valid_575057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575058: Call_ClustersListByResourceGroup_575049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Clusters associated within the specified resource group.
  ## 
  let valid = call_575058.validator(path, query, header, formData, body)
  let scheme = call_575058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575058.url(scheme.get, call_575058.host, call_575058.base,
                         call_575058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575058, url, valid)

proc call*(call_575059: Call_ClustersListByResourceGroup_575049;
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
  var path_575060 = newJObject()
  var query_575061 = newJObject()
  add(path_575060, "resourceGroupName", newJString(resourceGroupName))
  add(query_575061, "api-version", newJString(apiVersion))
  add(path_575060, "subscriptionId", newJString(subscriptionId))
  add(query_575061, "maxresults", newJInt(maxresults))
  add(query_575061, "$select", newJString(Select))
  add(query_575061, "$filter", newJString(Filter))
  result = call_575059.call(path_575060, query_575061, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_575049(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters",
    validator: validate_ClustersListByResourceGroup_575050, base: "",
    url: url_ClustersListByResourceGroup_575051, schemes: {Scheme.Https})
type
  Call_ClustersCreate_575073 = ref object of OpenApiRestCall_574466
proc url_ClustersCreate_575075(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersCreate_575074(path: JsonNode; query: JsonNode;
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
  var valid_575093 = path.getOrDefault("clusterName")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "clusterName", valid_575093
  var valid_575094 = path.getOrDefault("resourceGroupName")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "resourceGroupName", valid_575094
  var valid_575095 = path.getOrDefault("subscriptionId")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "subscriptionId", valid_575095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575096 = query.getOrDefault("api-version")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "api-version", valid_575096
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

proc call*(call_575098: Call_ClustersCreate_575073; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a cluster. A cluster is a collection of compute nodes. Multiple jobs can be run on the same cluster.
  ## 
  let valid = call_575098.validator(path, query, header, formData, body)
  let scheme = call_575098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575098.url(scheme.get, call_575098.host, call_575098.base,
                         call_575098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575098, url, valid)

proc call*(call_575099: Call_ClustersCreate_575073; clusterName: string;
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
  var path_575100 = newJObject()
  var query_575101 = newJObject()
  var body_575102 = newJObject()
  add(path_575100, "clusterName", newJString(clusterName))
  add(path_575100, "resourceGroupName", newJString(resourceGroupName))
  add(query_575101, "api-version", newJString(apiVersion))
  add(path_575100, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575102 = parameters
  result = call_575099.call(path_575100, query_575101, nil, nil, body_575102)

var clustersCreate* = Call_ClustersCreate_575073(name: "clustersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
    validator: validate_ClustersCreate_575074, base: "", url: url_ClustersCreate_575075,
    schemes: {Scheme.Https})
type
  Call_ClustersGet_575062 = ref object of OpenApiRestCall_574466
proc url_ClustersGet_575064(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersGet_575063(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575065 = path.getOrDefault("clusterName")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "clusterName", valid_575065
  var valid_575066 = path.getOrDefault("resourceGroupName")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "resourceGroupName", valid_575066
  var valid_575067 = path.getOrDefault("subscriptionId")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "subscriptionId", valid_575067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575068 = query.getOrDefault("api-version")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "api-version", valid_575068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575069: Call_ClustersGet_575062; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Cluster.
  ## 
  let valid = call_575069.validator(path, query, header, formData, body)
  let scheme = call_575069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575069.url(scheme.get, call_575069.host, call_575069.base,
                         call_575069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575069, url, valid)

proc call*(call_575070: Call_ClustersGet_575062; clusterName: string;
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
  var path_575071 = newJObject()
  var query_575072 = newJObject()
  add(path_575071, "clusterName", newJString(clusterName))
  add(path_575071, "resourceGroupName", newJString(resourceGroupName))
  add(query_575072, "api-version", newJString(apiVersion))
  add(path_575071, "subscriptionId", newJString(subscriptionId))
  result = call_575070.call(path_575071, query_575072, nil, nil, nil)

var clustersGet* = Call_ClustersGet_575062(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
                                        validator: validate_ClustersGet_575063,
                                        base: "", url: url_ClustersGet_575064,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_575114 = ref object of OpenApiRestCall_574466
proc url_ClustersUpdate_575116(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersUpdate_575115(path: JsonNode; query: JsonNode;
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
  var valid_575117 = path.getOrDefault("clusterName")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "clusterName", valid_575117
  var valid_575118 = path.getOrDefault("resourceGroupName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "resourceGroupName", valid_575118
  var valid_575119 = path.getOrDefault("subscriptionId")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "subscriptionId", valid_575119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575120 = query.getOrDefault("api-version")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "api-version", valid_575120
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

proc call*(call_575122: Call_ClustersUpdate_575114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the properties of a given cluster.
  ## 
  let valid = call_575122.validator(path, query, header, formData, body)
  let scheme = call_575122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575122.url(scheme.get, call_575122.host, call_575122.base,
                         call_575122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575122, url, valid)

proc call*(call_575123: Call_ClustersUpdate_575114; clusterName: string;
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
  var path_575124 = newJObject()
  var query_575125 = newJObject()
  var body_575126 = newJObject()
  add(path_575124, "clusterName", newJString(clusterName))
  add(path_575124, "resourceGroupName", newJString(resourceGroupName))
  add(query_575125, "api-version", newJString(apiVersion))
  add(path_575124, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575126 = parameters
  result = call_575123.call(path_575124, query_575125, nil, nil, body_575126)

var clustersUpdate* = Call_ClustersUpdate_575114(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
    validator: validate_ClustersUpdate_575115, base: "", url: url_ClustersUpdate_575116,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_575103 = ref object of OpenApiRestCall_574466
proc url_ClustersDelete_575105(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersDelete_575104(path: JsonNode; query: JsonNode;
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
  var valid_575106 = path.getOrDefault("clusterName")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "clusterName", valid_575106
  var valid_575107 = path.getOrDefault("resourceGroupName")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "resourceGroupName", valid_575107
  var valid_575108 = path.getOrDefault("subscriptionId")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "subscriptionId", valid_575108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575109 = query.getOrDefault("api-version")
  valid_575109 = validateParameter(valid_575109, JString, required = true,
                                 default = nil)
  if valid_575109 != nil:
    section.add "api-version", valid_575109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575110: Call_ClustersDelete_575103; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cluster.
  ## 
  let valid = call_575110.validator(path, query, header, formData, body)
  let scheme = call_575110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575110.url(scheme.get, call_575110.host, call_575110.base,
                         call_575110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575110, url, valid)

proc call*(call_575111: Call_ClustersDelete_575103; clusterName: string;
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
  var path_575112 = newJObject()
  var query_575113 = newJObject()
  add(path_575112, "clusterName", newJString(clusterName))
  add(path_575112, "resourceGroupName", newJString(resourceGroupName))
  add(query_575113, "api-version", newJString(apiVersion))
  add(path_575112, "subscriptionId", newJString(subscriptionId))
  result = call_575111.call(path_575112, query_575113, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_575103(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}",
    validator: validate_ClustersDelete_575104, base: "", url: url_ClustersDelete_575105,
    schemes: {Scheme.Https})
type
  Call_ClustersListRemoteLoginInformation_575127 = ref object of OpenApiRestCall_574466
proc url_ClustersListRemoteLoginInformation_575129(protocol: Scheme; host: string;
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

proc validate_ClustersListRemoteLoginInformation_575128(path: JsonNode;
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
  var valid_575130 = path.getOrDefault("clusterName")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "clusterName", valid_575130
  var valid_575131 = path.getOrDefault("resourceGroupName")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "resourceGroupName", valid_575131
  var valid_575132 = path.getOrDefault("subscriptionId")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "subscriptionId", valid_575132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575133 = query.getOrDefault("api-version")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "api-version", valid_575133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575134: Call_ClustersListRemoteLoginInformation_575127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address, port of all the compute nodes in the cluster.
  ## 
  let valid = call_575134.validator(path, query, header, formData, body)
  let scheme = call_575134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575134.url(scheme.get, call_575134.host, call_575134.base,
                         call_575134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575134, url, valid)

proc call*(call_575135: Call_ClustersListRemoteLoginInformation_575127;
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
  var path_575136 = newJObject()
  var query_575137 = newJObject()
  add(path_575136, "clusterName", newJString(clusterName))
  add(path_575136, "resourceGroupName", newJString(resourceGroupName))
  add(query_575137, "api-version", newJString(apiVersion))
  add(path_575136, "subscriptionId", newJString(subscriptionId))
  result = call_575135.call(path_575136, query_575137, nil, nil, nil)

var clustersListRemoteLoginInformation* = Call_ClustersListRemoteLoginInformation_575127(
    name: "clustersListRemoteLoginInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/clusters/{clusterName}/listRemoteLoginInformation",
    validator: validate_ClustersListRemoteLoginInformation_575128, base: "",
    url: url_ClustersListRemoteLoginInformation_575129, schemes: {Scheme.Https})
type
  Call_FileServersListByResourceGroup_575138 = ref object of OpenApiRestCall_574466
proc url_FileServersListByResourceGroup_575140(protocol: Scheme; host: string;
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

proc validate_FileServersListByResourceGroup_575139(path: JsonNode;
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
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $select: JString
  ##          : An OData $select clause. Used to select the properties to be returned in the GET response.
  ##   $filter: JString
  ##          : An OData $filter clause. Used to filter results that are returned in the GET response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575143 = query.getOrDefault("api-version")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "api-version", valid_575143
  var valid_575144 = query.getOrDefault("maxresults")
  valid_575144 = validateParameter(valid_575144, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575144 != nil:
    section.add "maxresults", valid_575144
  var valid_575145 = query.getOrDefault("$select")
  valid_575145 = validateParameter(valid_575145, JString, required = false,
                                 default = nil)
  if valid_575145 != nil:
    section.add "$select", valid_575145
  var valid_575146 = query.getOrDefault("$filter")
  valid_575146 = validateParameter(valid_575146, JString, required = false,
                                 default = nil)
  if valid_575146 != nil:
    section.add "$filter", valid_575146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575147: Call_FileServersListByResourceGroup_575138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a formatted list of file servers and their properties associated within the specified resource group.
  ## 
  let valid = call_575147.validator(path, query, header, formData, body)
  let scheme = call_575147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575147.url(scheme.get, call_575147.host, call_575147.base,
                         call_575147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575147, url, valid)

proc call*(call_575148: Call_FileServersListByResourceGroup_575138;
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
  var path_575149 = newJObject()
  var query_575150 = newJObject()
  add(path_575149, "resourceGroupName", newJString(resourceGroupName))
  add(query_575150, "api-version", newJString(apiVersion))
  add(path_575149, "subscriptionId", newJString(subscriptionId))
  add(query_575150, "maxresults", newJInt(maxresults))
  add(query_575150, "$select", newJString(Select))
  add(query_575150, "$filter", newJString(Filter))
  result = call_575148.call(path_575149, query_575150, nil, nil, nil)

var fileServersListByResourceGroup* = Call_FileServersListByResourceGroup_575138(
    name: "fileServersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers",
    validator: validate_FileServersListByResourceGroup_575139, base: "",
    url: url_FileServersListByResourceGroup_575140, schemes: {Scheme.Https})
type
  Call_FileServersCreate_575162 = ref object of OpenApiRestCall_574466
proc url_FileServersCreate_575164(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersCreate_575163(path: JsonNode; query: JsonNode;
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
  var valid_575165 = path.getOrDefault("resourceGroupName")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "resourceGroupName", valid_575165
  var valid_575166 = path.getOrDefault("subscriptionId")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "subscriptionId", valid_575166
  var valid_575167 = path.getOrDefault("fileServerName")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "fileServerName", valid_575167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575168 = query.getOrDefault("api-version")
  valid_575168 = validateParameter(valid_575168, JString, required = true,
                                 default = nil)
  if valid_575168 != nil:
    section.add "api-version", valid_575168
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

proc call*(call_575170: Call_FileServersCreate_575162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a file server.
  ## 
  let valid = call_575170.validator(path, query, header, formData, body)
  let scheme = call_575170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575170.url(scheme.get, call_575170.host, call_575170.base,
                         call_575170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575170, url, valid)

proc call*(call_575171: Call_FileServersCreate_575162; resourceGroupName: string;
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
  var path_575172 = newJObject()
  var query_575173 = newJObject()
  var body_575174 = newJObject()
  add(path_575172, "resourceGroupName", newJString(resourceGroupName))
  add(query_575173, "api-version", newJString(apiVersion))
  add(path_575172, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575174 = parameters
  add(path_575172, "fileServerName", newJString(fileServerName))
  result = call_575171.call(path_575172, query_575173, nil, nil, body_575174)

var fileServersCreate* = Call_FileServersCreate_575162(name: "fileServersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers/{fileServerName}",
    validator: validate_FileServersCreate_575163, base: "",
    url: url_FileServersCreate_575164, schemes: {Scheme.Https})
type
  Call_FileServersGet_575151 = ref object of OpenApiRestCall_574466
proc url_FileServersGet_575153(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersGet_575152(path: JsonNode; query: JsonNode;
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
  var valid_575154 = path.getOrDefault("resourceGroupName")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "resourceGroupName", valid_575154
  var valid_575155 = path.getOrDefault("subscriptionId")
  valid_575155 = validateParameter(valid_575155, JString, required = true,
                                 default = nil)
  if valid_575155 != nil:
    section.add "subscriptionId", valid_575155
  var valid_575156 = path.getOrDefault("fileServerName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "fileServerName", valid_575156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575157 = query.getOrDefault("api-version")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "api-version", valid_575157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575158: Call_FileServersGet_575151; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Cluster.
  ## 
  let valid = call_575158.validator(path, query, header, formData, body)
  let scheme = call_575158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575158.url(scheme.get, call_575158.host, call_575158.base,
                         call_575158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575158, url, valid)

proc call*(call_575159: Call_FileServersGet_575151; resourceGroupName: string;
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
  var path_575160 = newJObject()
  var query_575161 = newJObject()
  add(path_575160, "resourceGroupName", newJString(resourceGroupName))
  add(query_575161, "api-version", newJString(apiVersion))
  add(path_575160, "subscriptionId", newJString(subscriptionId))
  add(path_575160, "fileServerName", newJString(fileServerName))
  result = call_575159.call(path_575160, query_575161, nil, nil, nil)

var fileServersGet* = Call_FileServersGet_575151(name: "fileServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers/{fileServerName}",
    validator: validate_FileServersGet_575152, base: "", url: url_FileServersGet_575153,
    schemes: {Scheme.Https})
type
  Call_FileServersDelete_575175 = ref object of OpenApiRestCall_574466
proc url_FileServersDelete_575177(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersDelete_575176(path: JsonNode; query: JsonNode;
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
  var valid_575178 = path.getOrDefault("resourceGroupName")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "resourceGroupName", valid_575178
  var valid_575179 = path.getOrDefault("subscriptionId")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "subscriptionId", valid_575179
  var valid_575180 = path.getOrDefault("fileServerName")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "fileServerName", valid_575180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575181 = query.getOrDefault("api-version")
  valid_575181 = validateParameter(valid_575181, JString, required = true,
                                 default = nil)
  if valid_575181 != nil:
    section.add "api-version", valid_575181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575182: Call_FileServersDelete_575175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a file Server.
  ## 
  let valid = call_575182.validator(path, query, header, formData, body)
  let scheme = call_575182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575182.url(scheme.get, call_575182.host, call_575182.base,
                         call_575182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575182, url, valid)

proc call*(call_575183: Call_FileServersDelete_575175; resourceGroupName: string;
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
  var path_575184 = newJObject()
  var query_575185 = newJObject()
  add(path_575184, "resourceGroupName", newJString(resourceGroupName))
  add(query_575185, "api-version", newJString(apiVersion))
  add(path_575184, "subscriptionId", newJString(subscriptionId))
  add(path_575184, "fileServerName", newJString(fileServerName))
  result = call_575183.call(path_575184, query_575185, nil, nil, nil)

var fileServersDelete* = Call_FileServersDelete_575175(name: "fileServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/fileServers/{fileServerName}",
    validator: validate_FileServersDelete_575176, base: "",
    url: url_FileServersDelete_575177, schemes: {Scheme.Https})
type
  Call_JobsListByResourceGroup_575186 = ref object of OpenApiRestCall_574466
proc url_JobsListByResourceGroup_575188(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByResourceGroup_575187(path: JsonNode; query: JsonNode;
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
  var valid_575189 = path.getOrDefault("resourceGroupName")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "resourceGroupName", valid_575189
  var valid_575190 = path.getOrDefault("subscriptionId")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "subscriptionId", valid_575190
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
  var valid_575191 = query.getOrDefault("api-version")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "api-version", valid_575191
  var valid_575192 = query.getOrDefault("maxresults")
  valid_575192 = validateParameter(valid_575192, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575192 != nil:
    section.add "maxresults", valid_575192
  var valid_575193 = query.getOrDefault("$select")
  valid_575193 = validateParameter(valid_575193, JString, required = false,
                                 default = nil)
  if valid_575193 != nil:
    section.add "$select", valid_575193
  var valid_575194 = query.getOrDefault("$filter")
  valid_575194 = validateParameter(valid_575194, JString, required = false,
                                 default = nil)
  if valid_575194 != nil:
    section.add "$filter", valid_575194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575195: Call_JobsListByResourceGroup_575186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Batch AI jobs associated within the specified resource group.
  ## 
  let valid = call_575195.validator(path, query, header, formData, body)
  let scheme = call_575195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575195.url(scheme.get, call_575195.host, call_575195.base,
                         call_575195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575195, url, valid)

proc call*(call_575196: Call_JobsListByResourceGroup_575186;
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
  var path_575197 = newJObject()
  var query_575198 = newJObject()
  add(path_575197, "resourceGroupName", newJString(resourceGroupName))
  add(query_575198, "api-version", newJString(apiVersion))
  add(path_575197, "subscriptionId", newJString(subscriptionId))
  add(query_575198, "maxresults", newJInt(maxresults))
  add(query_575198, "$select", newJString(Select))
  add(query_575198, "$filter", newJString(Filter))
  result = call_575196.call(path_575197, query_575198, nil, nil, nil)

var jobsListByResourceGroup* = Call_JobsListByResourceGroup_575186(
    name: "jobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs",
    validator: validate_JobsListByResourceGroup_575187, base: "",
    url: url_JobsListByResourceGroup_575188, schemes: {Scheme.Https})
type
  Call_JobsCreate_575210 = ref object of OpenApiRestCall_574466
proc url_JobsCreate_575212(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCreate_575211(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575213 = path.getOrDefault("resourceGroupName")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "resourceGroupName", valid_575213
  var valid_575214 = path.getOrDefault("subscriptionId")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "subscriptionId", valid_575214
  var valid_575215 = path.getOrDefault("jobName")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "jobName", valid_575215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575216 = query.getOrDefault("api-version")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "api-version", valid_575216
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

proc call*(call_575218: Call_JobsCreate_575210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a Job that gets executed on a cluster.
  ## 
  let valid = call_575218.validator(path, query, header, formData, body)
  let scheme = call_575218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575218.url(scheme.get, call_575218.host, call_575218.base,
                         call_575218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575218, url, valid)

proc call*(call_575219: Call_JobsCreate_575210; resourceGroupName: string;
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
  var path_575220 = newJObject()
  var query_575221 = newJObject()
  var body_575222 = newJObject()
  add(path_575220, "resourceGroupName", newJString(resourceGroupName))
  add(query_575221, "api-version", newJString(apiVersion))
  add(path_575220, "subscriptionId", newJString(subscriptionId))
  add(path_575220, "jobName", newJString(jobName))
  if parameters != nil:
    body_575222 = parameters
  result = call_575219.call(path_575220, query_575221, nil, nil, body_575222)

var jobsCreate* = Call_JobsCreate_575210(name: "jobsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}",
                                      validator: validate_JobsCreate_575211,
                                      base: "", url: url_JobsCreate_575212,
                                      schemes: {Scheme.Https})
type
  Call_JobsGet_575199 = ref object of OpenApiRestCall_574466
proc url_JobsGet_575201(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_575200(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575202 = path.getOrDefault("resourceGroupName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "resourceGroupName", valid_575202
  var valid_575203 = path.getOrDefault("subscriptionId")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "subscriptionId", valid_575203
  var valid_575204 = path.getOrDefault("jobName")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "jobName", valid_575204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575205 = query.getOrDefault("api-version")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "api-version", valid_575205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575206: Call_JobsGet_575199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Batch AI job.
  ## 
  let valid = call_575206.validator(path, query, header, formData, body)
  let scheme = call_575206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575206.url(scheme.get, call_575206.host, call_575206.base,
                         call_575206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575206, url, valid)

proc call*(call_575207: Call_JobsGet_575199; resourceGroupName: string;
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
  var path_575208 = newJObject()
  var query_575209 = newJObject()
  add(path_575208, "resourceGroupName", newJString(resourceGroupName))
  add(query_575209, "api-version", newJString(apiVersion))
  add(path_575208, "subscriptionId", newJString(subscriptionId))
  add(path_575208, "jobName", newJString(jobName))
  result = call_575207.call(path_575208, query_575209, nil, nil, nil)

var jobsGet* = Call_JobsGet_575199(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}",
                                validator: validate_JobsGet_575200, base: "",
                                url: url_JobsGet_575201, schemes: {Scheme.Https})
type
  Call_JobsDelete_575223 = ref object of OpenApiRestCall_574466
proc url_JobsDelete_575225(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_575224(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575226 = path.getOrDefault("resourceGroupName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "resourceGroupName", valid_575226
  var valid_575227 = path.getOrDefault("subscriptionId")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "subscriptionId", valid_575227
  var valid_575228 = path.getOrDefault("jobName")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "jobName", valid_575228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575229 = query.getOrDefault("api-version")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "api-version", valid_575229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575230: Call_JobsDelete_575223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Batch AI job.
  ## 
  let valid = call_575230.validator(path, query, header, formData, body)
  let scheme = call_575230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575230.url(scheme.get, call_575230.host, call_575230.base,
                         call_575230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575230, url, valid)

proc call*(call_575231: Call_JobsDelete_575223; resourceGroupName: string;
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
  var path_575232 = newJObject()
  var query_575233 = newJObject()
  add(path_575232, "resourceGroupName", newJString(resourceGroupName))
  add(query_575233, "api-version", newJString(apiVersion))
  add(path_575232, "subscriptionId", newJString(subscriptionId))
  add(path_575232, "jobName", newJString(jobName))
  result = call_575231.call(path_575232, query_575233, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_575223(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}",
                                      validator: validate_JobsDelete_575224,
                                      base: "", url: url_JobsDelete_575225,
                                      schemes: {Scheme.Https})
type
  Call_JobsListOutputFiles_575234 = ref object of OpenApiRestCall_574466
proc url_JobsListOutputFiles_575236(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListOutputFiles_575235(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all files inside the given output directory (Only if the output directory is on Azure File Share or Azure Storage container).
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
  var valid_575237 = path.getOrDefault("resourceGroupName")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = nil)
  if valid_575237 != nil:
    section.add "resourceGroupName", valid_575237
  var valid_575238 = path.getOrDefault("subscriptionId")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "subscriptionId", valid_575238
  var valid_575239 = path.getOrDefault("jobName")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "jobName", valid_575239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   linkexpiryinminutes: JInt
  ##                      : The number of minutes after which the download link will expire.
  ##   outputdirectoryid: JString (required)
  ##                    : Id of the job output directory. This is the OutputDirectory-->id parameter that is given by the user during Create Job.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575240 = query.getOrDefault("api-version")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "api-version", valid_575240
  var valid_575241 = query.getOrDefault("maxresults")
  valid_575241 = validateParameter(valid_575241, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575241 != nil:
    section.add "maxresults", valid_575241
  var valid_575242 = query.getOrDefault("linkexpiryinminutes")
  valid_575242 = validateParameter(valid_575242, JInt, required = false,
                                 default = newJInt(60))
  if valid_575242 != nil:
    section.add "linkexpiryinminutes", valid_575242
  var valid_575243 = query.getOrDefault("outputdirectoryid")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "outputdirectoryid", valid_575243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575244: Call_JobsListOutputFiles_575234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all files inside the given output directory (Only if the output directory is on Azure File Share or Azure Storage container).
  ## 
  let valid = call_575244.validator(path, query, header, formData, body)
  let scheme = call_575244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575244.url(scheme.get, call_575244.host, call_575244.base,
                         call_575244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575244, url, valid)

proc call*(call_575245: Call_JobsListOutputFiles_575234; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          outputdirectoryid: string; maxresults: int = 1000;
          linkexpiryinminutes: int = 60): Recallable =
  ## jobsListOutputFiles
  ## List all files inside the given output directory (Only if the output directory is on Azure File Share or Azure Storage container).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Specifies the version of API used for this request.
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
  var path_575246 = newJObject()
  var query_575247 = newJObject()
  add(path_575246, "resourceGroupName", newJString(resourceGroupName))
  add(query_575247, "api-version", newJString(apiVersion))
  add(path_575246, "subscriptionId", newJString(subscriptionId))
  add(path_575246, "jobName", newJString(jobName))
  add(query_575247, "maxresults", newJInt(maxresults))
  add(query_575247, "linkexpiryinminutes", newJInt(linkexpiryinminutes))
  add(query_575247, "outputdirectoryid", newJString(outputdirectoryid))
  result = call_575245.call(path_575246, query_575247, nil, nil, nil)

var jobsListOutputFiles* = Call_JobsListOutputFiles_575234(
    name: "jobsListOutputFiles", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}/listOutputFiles",
    validator: validate_JobsListOutputFiles_575235, base: "",
    url: url_JobsListOutputFiles_575236, schemes: {Scheme.Https})
type
  Call_JobsListRemoteLoginInformation_575248 = ref object of OpenApiRestCall_574466
proc url_JobsListRemoteLoginInformation_575250(protocol: Scheme; host: string;
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

proc validate_JobsListRemoteLoginInformation_575249(path: JsonNode;
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
  var valid_575251 = path.getOrDefault("resourceGroupName")
  valid_575251 = validateParameter(valid_575251, JString, required = true,
                                 default = nil)
  if valid_575251 != nil:
    section.add "resourceGroupName", valid_575251
  var valid_575252 = path.getOrDefault("subscriptionId")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "subscriptionId", valid_575252
  var valid_575253 = path.getOrDefault("jobName")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "jobName", valid_575253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the version of API used for this request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575254 = query.getOrDefault("api-version")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "api-version", valid_575254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575255: Call_JobsListRemoteLoginInformation_575248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the IP address and port information of all the compute nodes which are used for job execution.
  ## 
  let valid = call_575255.validator(path, query, header, formData, body)
  let scheme = call_575255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575255.url(scheme.get, call_575255.host, call_575255.base,
                         call_575255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575255, url, valid)

proc call*(call_575256: Call_JobsListRemoteLoginInformation_575248;
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
  var path_575257 = newJObject()
  var query_575258 = newJObject()
  add(path_575257, "resourceGroupName", newJString(resourceGroupName))
  add(query_575258, "api-version", newJString(apiVersion))
  add(path_575257, "subscriptionId", newJString(subscriptionId))
  add(path_575257, "jobName", newJString(jobName))
  result = call_575256.call(path_575257, query_575258, nil, nil, nil)

var jobsListRemoteLoginInformation* = Call_JobsListRemoteLoginInformation_575248(
    name: "jobsListRemoteLoginInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}/listRemoteLoginInformation",
    validator: validate_JobsListRemoteLoginInformation_575249, base: "",
    url: url_JobsListRemoteLoginInformation_575250, schemes: {Scheme.Https})
type
  Call_JobsTerminate_575259 = ref object of OpenApiRestCall_574466
proc url_JobsTerminate_575261(protocol: Scheme; host: string; base: string;
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

proc validate_JobsTerminate_575260(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_575266: Call_JobsTerminate_575259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Terminates a job.
  ## 
  let valid = call_575266.validator(path, query, header, formData, body)
  let scheme = call_575266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575266.url(scheme.get, call_575266.host, call_575266.base,
                         call_575266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575266, url, valid)

proc call*(call_575267: Call_JobsTerminate_575259; resourceGroupName: string;
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
  var path_575268 = newJObject()
  var query_575269 = newJObject()
  add(path_575268, "resourceGroupName", newJString(resourceGroupName))
  add(query_575269, "api-version", newJString(apiVersion))
  add(path_575268, "subscriptionId", newJString(subscriptionId))
  add(path_575268, "jobName", newJString(jobName))
  result = call_575267.call(path_575268, query_575269, nil, nil, nil)

var jobsTerminate* = Call_JobsTerminate_575259(name: "jobsTerminate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BatchAI/jobs/{jobName}/terminate",
    validator: validate_JobsTerminate_575260, base: "", url: url_JobsTerminate_575261,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
